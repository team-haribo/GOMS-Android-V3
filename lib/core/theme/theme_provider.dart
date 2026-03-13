import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/utils/settings_storage.dart';

/// ThemeMode를 관리하고 SharedPreferences에 영구 저장하는 Provider
final themeModeProvider = AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final index = await SettingsStorage.getThemeMode();
    // ThemeMode.values: [system(0), light(1), dark(2)]
    return ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await SettingsStorage.setThemeMode(mode.index);
    state = AsyncData(mode);
  }
}
