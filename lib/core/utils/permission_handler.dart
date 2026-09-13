import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandler {
  static Future<bool> requestCallPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final cameraGranted =
        statuses[Permission.camera] == PermissionStatus.granted;
    final micGranted =
        statuses[Permission.microphone] == PermissionStatus.granted;

    return cameraGranted && micGranted;
  }
}
