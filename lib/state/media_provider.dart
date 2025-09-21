import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/media_file.dart';
import '../services/storage_service.dart';

final mediaFolderProvider =
FutureProvider<Map<String, List<MediaFile>>>((ref) async {
  final storageService = StorageService();
  return await storageService.scanDeviceMediaByFolder();
});
