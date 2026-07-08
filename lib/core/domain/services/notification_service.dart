/// Firebase Cloud Messaging을 통한 푸시 알림을 담당하는 추상 서비스
abstract class NotificationService {
  /// 기기 토큰을 서버에 등록
  /// 
  /// 푸시 알림을 받기 위해 FCM 토큰을 서버에 저장합니다.
  Future<void> registerDeviceToken();

  /// 기기 토큰을 서버에서 삭제
  /// 
  /// 푸시 알림을 받지 않기 위해 FCM 토큰을 서버에서 제거합니다.
  Future<void> deleteDeviceToken();

  /// 현재 FCM 토큰 조회
  Future<String?> getDeviceToken();

  /// FCM 토큰 새로 고침
  /// 
  /// 토큰이 갱신되었을 때 호출되어 새 토큰을 서버에 등록합니다.
  Future<void> refreshDeviceToken();
}
