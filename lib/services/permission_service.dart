import 'package:permission_handler/permission_handler.dart';


class PermissionService {
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}