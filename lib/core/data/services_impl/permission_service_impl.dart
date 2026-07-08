import 'package:permission_handler/permission_handler.dart';
import 'package:goms/core/domain/services/permission_service.dart';

/// PermissionService의 구현체
class PermissionServiceImpl implements PermissionService {
  @override
  Future<PermissionStatus> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      status = await Permission.notification.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return status;
  }

  @override
  Future<PermissionStatus> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return status;
  }

  @override
  Future<PermissionStatus> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return status;
  }

  @override
  Future<PermissionStatus> getNotificationPermissionStatus() async =>
      Permission.notification.status;

  @override
  Future<PermissionStatus> getCameraPermissionStatus() async =>
      Permission.camera.status;

  @override
  Future<PermissionStatus> getLocationPermissionStatus() async =>
      Permission.location.status;

  @override
  Future<void> openAppSettings() async => await openAppSettings();
}
