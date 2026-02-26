import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';

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

        // Cursor / Text Selection
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: CupertinoColors.systemBlue,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: AppColors.mainColor),
          titleTextStyle: AppTextStyles.title2.withColor(AppColors.mainColor),
        ),

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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
