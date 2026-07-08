/// 앱 설정값 저장/조회를 담당하는 추상 서비스
/// 
/// SettingsStorage에 대한 의존성을 추상화하여, 테스트 및 의존성 주입을 용이하게 합니다.
abstract class SettingsService {
  /// 화면 시계 표시 여부 조회
  Future<bool> getShowClock();

  /// 화면 시계 표시 여부 저장
  Future<void> setShowClock(bool value);

  /// 외출 푸시 알림 활성화 여부 조회
  Future<bool> getOutingPushAlarm();

  /// 외출 푸시 알림 활성화 여부 저장
  Future<void> setOutingPushAlarm(bool value);

  /// 카메라 실행 여부 조회
  Future<bool> getCameraLaunch();

  /// 카메라 실행 여부 저장
  Future<void> setCameraLaunch(bool value);

  /// 테마 모드 조회 (0=system, 1=light, 2=dark)
  Future<int> getThemeMode();

  /// 테마 모드 저장 (0=system, 1=light, 2=dark)
  Future<void> setThemeMode(int value);
}
