import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱 테마 설정
class AppTheme {
  AppTheme._();

  /// 라이트 테마
  static ThemeData get light => _LightTheme.theme;

  /// 다크 테마
  static ThemeData get dark => _DarkTheme.theme;
}

// ==================== Light Theme ====================
class _LightTheme {
  _LightTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.bgSurface,
      background: AppColors.background,
      error: AppColors.negative,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
}

// ==================== Dark Theme ====================
class _DarkTheme {
  _DarkTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.bgSurfaceDark,
      error: AppColors.negative,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
  );
}
