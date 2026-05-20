import 'package:goms/core/domain/services/settings_service.dart';
import 'package:goms/features/notification/presentation/notification_remote_datasource.dart';

/// 푸시 알림 비활성화 UseCase
///
/// 다음의 단계를 거쳐 푸시 알림을 비활성화합니다:
/// 1. 기기 토큰을 서버에서 삭제
/// 2. 설정값 저장
class DisablePushNotificationUseCase {
  final SettingsService _settingsService;
  final NotificationRemoteDataSource _notificationDataSource;

  DisablePushNotificationUseCase({
    required SettingsService settingsService,
    required NotificationRemoteDataSource notificationDataSource,
  })  : _settingsService = settingsService,
        _notificationDataSource = notificationDataSource;

  /// 푸시 알림 비활성화
  Future<bool> call() async {
    try {
      await _notificationDataSource.deleteDeviceToken();
      await _settingsService.setOutingPushAlarm(false);
      return true;
    } catch (_) {
      return false;
    }
  }
}
