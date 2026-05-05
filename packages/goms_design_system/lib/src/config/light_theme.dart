import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goms_design_system/src/typography/app_text_styles.dart';
import 'package:goms_design_system/src/colors/app_colors.dart';

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

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          shape: CircleBorder(),
        ),

        // Cursor / Text Selection
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: CupertinoColors.systemBlue,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: AppColors.mainColor),
          titleTextStyle: AppTextStyles.title2.withColor(AppColors.mainColor),
        ),

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

        // Input Decoration
        inputDecorationTheme: (() {
          final borderRadius = BorderRadius.circular(12);
          final noneBorder = OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          );
          final errorBorder = OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: AppColors.negative, width: 1),
          );
          return InputDecorationTheme(
            filled: true,
            fillColor: AppColors.bgSurface,
            labelStyle: AppTextStyles.text2.withColor(AppColors.mainText),
            hintStyle: AppTextStyles.text3.withColor(AppColors.sub2),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: noneBorder,
            enabledBorder: noneBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            disabledBorder: noneBorder,
          );
        })(),

        dividerTheme: const DividerThemeData(
          color: AppColors.button,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      );
}
