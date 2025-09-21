import 'package:photo_manager/photo_manager.dart';
import '../data/models/media_file.dart';

class StorageService {
  /// Returns a Map where the key is the folder (album) name,
  /// and the value is a list of media files in that folder.
  Future<Map<String, List<MediaFile>>> scanDeviceMediaByFolder() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (!permitted.isAuth) {
      await PhotoManager.openSetting();
      return {};
    }

    final Map<String, List<MediaFile>> folderMap = {};

    // Get both video and audio albums
    final videoAlbums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
      onlyAll: false,
    );

    final audioAlbums = await PhotoManager.getAssetPathList(
      type: RequestType.audio,
      onlyAll: false,
    );

    final allAlbums = [...videoAlbums, ...audioAlbums];

    for (var album in allAlbums) {
      final assets = await album.getAssetListPaged(page: 0, size: 1000);

      for (var asset in assets) {
        final file = await asset.file;
        if (file == null) continue;

        final mediaType =
        asset.type == AssetType.video ? MediaType.video : MediaType.audio;

        final media = MediaFile(
          id: asset.id,
          title: asset.title ?? file.uri.pathSegments.last,
          path: file.path,
          type: mediaType,
          duration: asset.type == AssetType.video ? asset.videoDuration : null,
        );

        // Group by folder (album) name
        folderMap.putIfAbsent(album.name, () => []);
        folderMap[album.name]!.add(media);
      }
    }

    return folderMap;
  }
}
