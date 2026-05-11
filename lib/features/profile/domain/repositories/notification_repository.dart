/// 프로필 기능의 알림 관련 저장소 인터페이스
abstract class NotificationRepository {
  /// 기기 토큰을 서버에 등록
  Future<void> registerDeviceToken();

  /// 기기 토큰을 서버에서 삭제
  Future<void> deleteDeviceToken();
}
