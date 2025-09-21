import 'package:flutter/material.dart';
import '../../../data/models/media_file.dart';
import '../../../services/player_service.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final MediaFile media;
  const PlayerScreen({super.key, required this.media});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final PlayerService _player = PlayerService();
  VideoPlayerController? _vc;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _player.initMedia(widget.media);
    _vc = _player.videoController;
    if (_vc != null) {
      await _vc!.setLooping(false);
    }
    setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.media.title)),
      body: _initialized
          ? widget.media.type == MediaType.video
                ? Center(
                    child: _vc != null
                        ? AspectRatio(
                            aspectRatio: _vc!.value.aspectRatio,
                            child: VideoPlayer(_vc!),
                          )
                        : const Text('Unable to play video'),
                  )
                : Center(child: Text('Playing audio: ${widget.media.title}'))
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_vc != null) {
            setState(() {
              _vc!.value.isPlaying ? _player.pause() : _player.play();
            });
          } else {
            // audio toggle
            // Not tracking playing state here for brevity
            await _player.play();
          }
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
