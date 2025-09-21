import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import '../../../../data/models/media_file.dart' as mfile;
import 'package:go_router/go_router.dart';
import 'dart:typed_data';

class VideoTile extends StatefulWidget {
  final mfile.MediaFile media;
  const VideoTile({super.key, required this.media});

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  String? _thumbnailPath;
  String? _fileSize;
  String? _formattedDate;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    final file = File(widget.media.path);

    // Get size
    final sizeBytes = await file.length();
    final sizeMB = sizeBytes / (1024 * 1024);
    _fileSize = sizeMB < 1
        ? '${(sizeBytes / 1024).toStringAsFixed(0)} KB'
        : '${sizeMB.toStringAsFixed(1)} MB';

    // Get date
    final lastModified = await file.lastModified();
    _formattedDate = DateFormat('MMM dd').format(lastModified);

    // Get thumbnail
    if (widget.media.type == mfile.MediaType.video) {
      _thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: widget.media.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 120,
        quality: 50,
      );
    } else {
      // For audio, try reading metadata (album art)
      final metadata = await MetadataRetriever.fromFile(file);
      if (metadata.albumArt != null) {
        // convert albumArt (Uint8List) to memory image
        final imageBytes = metadata.albumArt!;
        setState(() {
          _thumbnailPath = null; // use album art via MemoryImage
          _thumbnailBytes = imageBytes;
        });
      }
    }

    setState(() {});
  }

  Uint8List? _thumbnailBytes; // for album art

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _thumbnailBytes != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          _thumbnailBytes!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      )
          : _thumbnailPath != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(
          File(_thumbnailPath!),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      )
          : Icon(
        widget.media.type == mfile.MediaType.video
            ? Icons.movie
            : Icons.music_note,
        size: 40,
      ),
      title: Text(
        widget.media.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${_fileSize ?? '...'} • ${_formattedDate ?? ''}',
        style: TextStyle(color: Colors.grey[600]),
      ),
      onTap: () => GoRouter.of(context).push('/player', extra: widget.media),
    );
  }
}
