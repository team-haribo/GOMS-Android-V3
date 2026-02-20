import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';
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

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgSurfaceDark,
      labelStyle: AppTextStyles.text2.withColor(AppColors.mainTextDark),
      hintStyle: AppTextStyles.text3.withColor(AppColors.sub2Dark),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.negative, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.negative, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
