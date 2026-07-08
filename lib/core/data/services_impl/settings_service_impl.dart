import 'package:goms/core/domain/services/settings_service.dart';
import 'package:goms/core/utils/settings_storage.dart';

/// SettingsService의 구현체
/// 
/// SettingsStorage를 래핑하여 의존성 주입 및 테스트를 용이하게 합니다.
class SettingsServiceImpl implements SettingsService {
  @override
  Future<bool> getShowClock() => SettingsStorage.getShowClock();

  @override
  Future<void> setShowClock(bool value) => SettingsStorage.setShowClock(value);

  @override
  Future<bool> getOutingPushAlarm() => SettingsStorage.getOutingPushAlarm();

  @override
  Future<void> setOutingPushAlarm(bool value) =>
      SettingsStorage.setOutingPushAlarm(value);

  @override
  Future<bool> getCameraLaunch() => SettingsStorage.getCameraLaunch();

  @override
  Future<void> setCameraLaunch(bool value) =>
      SettingsStorage.setCameraLaunch(value);

  @override
  Future<int> getThemeMode() => SettingsStorage.getThemeMode();

  @override
  Future<void> setThemeMode(int value) => SettingsStorage.setThemeMode(value);
}
