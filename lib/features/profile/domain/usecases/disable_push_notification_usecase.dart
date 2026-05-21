import 'package:goms/core/domain/services/settings_service.dart';
import 'package:goms/features/profile/domain/repositories/notification_repository.dart';

/// 푸시 알림 비활성화 UseCase
///
/// 다음의 단계를 거쳐 푸시 알림을 비활성화합니다:
/// 1. 기기 토큰을 서버에서 삭제
/// 2. 설정값 저장
class DisablePushNotificationUseCase {
  final SettingsService _settingsService;
  final NotificationRepository _notificationRepository;

  DisablePushNotificationUseCase({
    required SettingsService settingsService,
    required NotificationRepository notificationRepository,
  })  : _settingsService = settingsService,
        _notificationRepository = notificationRepository;

  /// 푸시 알림 비활성화
  Future<bool> call() async {
    try {
      await _notificationRepository.deleteDeviceToken();
      await _settingsService.setOutingPushAlarm(false);
      return true;
    } catch (_) {
      return false;
    }
  }
}
