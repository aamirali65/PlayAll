enum MediaType { video, audio }


class MediaFile {
  final String id;
  final String title;
  final String path;
  final MediaType type;
  final Duration? duration;


  MediaFile({
    required this.id,
    required this.title,
    required this.path,
    required this.type,
    this.duration,
  });
}