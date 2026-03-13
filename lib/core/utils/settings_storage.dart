import 'package:shared_preferences/shared_preferences.dart';

/// 앱 설정값을 SharedPreferences에 영구 저장/조회하는 유틸
class SettingsStorage {
  SettingsStorage._();

  static const _keyShowClock = 'settings_show_clock';
  static const _keyOutingPushAlarm = 'settings_outing_push_alarm';
  static const _keyCameraLaunch = 'settings_camera_launch';
  static const _keyThemeMode = 'settings_theme_mode';

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  static Future<bool> getShowClock() async =>
      (await _instance).getBool(_keyShowClock) ?? false;

  static Future<void> setShowClock(bool value) async =>
      (await _instance).setBool(_keyShowClock, value);

  static Future<bool> getOutingPushAlarm() async =>
      (await _instance).getBool(_keyOutingPushAlarm) ?? true;

  static Future<void> setOutingPushAlarm(bool value) async =>
      (await _instance).setBool(_keyOutingPushAlarm, value);

  static Future<bool> getCameraLaunch() async =>
      (await _instance).getBool(_keyCameraLaunch) ?? false;

  static Future<void> setCameraLaunch(bool value) async =>
      (await _instance).setBool(_keyCameraLaunch, value);

  /// ThemeMode 인덱스 저장 (0=system, 1=light, 2=dark)
  static Future<int> getThemeMode() async =>
      (await _instance).getInt(_keyThemeMode) ?? 0;

  static Future<void> setThemeMode(int value) async =>
      (await _instance).setInt(_keyThemeMode, value);
}
