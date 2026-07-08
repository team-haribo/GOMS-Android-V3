import 'package:permission_handler/permission_handler.dart';

/// Permission 요청 및 상태 확인을 담당하는 추상 서비스
abstract class PermissionService {
  /// Notification 권한 요청
  /// 
  /// 반환값: PermissionStatus (granted, denied, permanentlyDenied 등)
  Future<PermissionStatus> requestNotificationPermission();

  /// Camera 권한 요청
  Future<PermissionStatus> requestCameraPermission();

  /// Location 권한 요청
  Future<PermissionStatus> requestLocationPermission();

  /// 현재 Notification 권한 상태 확인
  Future<PermissionStatus> getNotificationPermissionStatus();

  /// 현재 Camera 권한 상태 확인
  Future<PermissionStatus> getCameraPermissionStatus();

  /// 현재 Location 권한 상태 확인
  Future<PermissionStatus> getLocationPermissionStatus();

  /// 앱 설정 페이지 열기 (권한이 영구 거부되었을 때)
  Future<void> openAppSettings();
}
