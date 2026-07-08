import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum AppThemeOption {
  @JsonValue('SYSTEM')
  system,

  @JsonValue('LIGHT')
  light,

  @JsonValue('DARK')
  dark,
}

extension AppThemeOptionX on AppThemeOption {
  String get label {
    switch (this) {
      case AppThemeOption.system:
        return '시스템 테마 설정';
      case AppThemeOption.light:
        return '라이트 모드';
      case AppThemeOption.dark:
        return '다크 모드';
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeOption.system:
        return ThemeMode.system;
      case AppThemeOption.light:
        return ThemeMode.light;
      case AppThemeOption.dark:
        return ThemeMode.dark;
    }
  }
}

extension ThemeModeX on ThemeMode {
  AppThemeOption get option {
    switch (this) {
      case ThemeMode.system:
        return AppThemeOption.system;
      case ThemeMode.light:
        return AppThemeOption.light;
      case ThemeMode.dark:
        return AppThemeOption.dark;
    }
  }
}
