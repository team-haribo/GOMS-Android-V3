import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 다크 테마 설정
class DarkTheme {
  DarkTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.mainColor,
      surface: AppColors.bgSurfaceDark,
      error: AppColors.negative,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgSurfaceDark,
      selectedItemColor: AppColors.sub2,
      unselectedItemColor: AppColors.sub2Dark,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
  );
}
