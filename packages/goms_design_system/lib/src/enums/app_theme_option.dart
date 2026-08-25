import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum AppThemeOption {
  @JsonValue('SYSTEM')
  system,

  @JsonValue('LIGHT')
  light,

  @JsonValue('DARK')
  dark;

  /// 테마 선택 목록 노출 순서 (Figma 569-10540)
  static const List<AppThemeOption> displayOrder = [dark, light, system];
}

extension AppThemeOptionX on AppThemeOption {
  String get label {
    switch (this) {
      case AppThemeOption.system:
        return '시스템 테마 설정';
      case AppThemeOption.light:
        return '라이트';
      case AppThemeOption.dark:
        return '다크 (기본)';
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
