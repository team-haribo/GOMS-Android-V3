import 'package:permission_handler/permission_handler.dart';
import 'package:goms/core/domain/services/permission_service.dart';
import 'package:goms/core/domain/services/settings_service.dart';
import 'package:goms/features/notification/presentation/notification_remote_datasource.dart';

/// 푸시 알림 활성화 UseCase
///
/// 다음의 단계를 거쳐 푸시 알림을 활성화합니다:
/// 1. 알림 권한 요청
/// 2. 기기 토큰을 서버에 등록
/// 3. 설정값 저장
class EnablePushNotificationUseCase {
  final PermissionService _permissionService;
  final SettingsService _settingsService;
  final NotificationRemoteDataSource _notificationDataSource;

  EnablePushNotificationUseCase({
    required PermissionService permissionService,
    required SettingsService settingsService,
    required NotificationRemoteDataSource notificationDataSource,
  })  : _permissionService = permissionService,
        _settingsService = settingsService,
        _notificationDataSource = notificationDataSource;

  /// 푸시 알림 활성화
  ///
  /// 알림 권한을 요청하고, 승인된 경우 기기 토큰을 서버에 등록합니다.
  /// 권한이 거부되었다면 false를 반환합니다.
  ///
  /// 반환값: true (성공) 또는 false (실패)
  Future<bool> call() async {
    final status = await _permissionService.requestNotificationPermission();

    // PermissionStatus가 granted가 아니면 실패
    if (status != PermissionStatus.granted) {
      return false;
    }

    try {
      await _notificationDataSource.registerDeviceToken();
      await _settingsService.setOutingPushAlarm(true);
      return true;
    } catch (_) {
      return false;
    }
  }
}
