import 'package:flutter/material.dart';
import '../../../data/models/media_file.dart';
import './widgets/video_tile.dart';

class FolderDetailScreen extends StatelessWidget {
  final String folderName;
  final List<MediaFile> files;

  const FolderDetailScreen({
    super.key,
    required this.folderName,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final item = files[index];
          return VideoTile(media: item);
        },
      ),
    );
  }
}
