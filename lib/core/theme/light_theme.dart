import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 라이트 테마 설정
class LightTheme {
  LightTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.mainColor,
      surface: AppColors.bgSurface,
      error: AppColors.negative,
    ),
    scaffoldBackgroundColor: AppColors.background,
    
    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgSurface,
      selectedItemColor: AppColors.sub2,
      unselectedItemColor: AppColors.button,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
  );
}
