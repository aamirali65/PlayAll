import 'dart:io'; // <-- ADD THIS
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import '../data/models/media_file.dart';

class PlayerService {
  VideoPlayerController? _videoController;
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> initMedia(MediaFile media) async {
    await dispose();
    if (media.type == MediaType.video) {
      // FIX: Use File() instead of Uri.parse()
      _videoController = VideoPlayerController.file(File(media.path));
      await _videoController!.initialize();
    } else {
      await audioPlayer.setFilePath(media.path);
    }
  }

  VideoPlayerController? get videoController => _videoController;

  Future<void> play() async {
    if (_videoController != null) {
      await _videoController!.play();
    } else {
      await audioPlayer.play();
    }
  }

  Future<void> pause() async {
    if (_videoController != null) {
      await _videoController!.pause();
    } else {
      await audioPlayer.pause();
    }
  }

  Future<void> dispose() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.dispose();
    } catch (_) {}
    try {
      await _videoController?.dispose();
      _videoController = null;
    } catch (_) {}
  }
}
