import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

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

    // ==================== Color Scheme ====================
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.negative,
    ),

    // ==================== Scaffold ====================
    scaffoldBackgroundColor: AppColors.background,

    // ==================== AppBar ====================
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: AppTextStyles.title2.copyWith(
        color: AppColors.textPrimary,
      ),
    ),

    // ==================== Text Theme ====================
    textTheme: TextTheme(
      displayLarge: AppTextStyles.title1.copyWith(color: AppColors.textPrimary),
      displayMedium: AppTextStyles.title2.copyWith(
        color: AppColors.textPrimary,
      ),
      displaySmall: AppTextStyles.title3.copyWith(color: AppColors.textPrimary),
      headlineLarge: AppTextStyles.title1.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineMedium: AppTextStyles.title2.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineSmall: AppTextStyles.title3.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyLarge: AppTextStyles.text1.copyWith(color: AppColors.textPrimary),
      bodyMedium: AppTextStyles.text2.copyWith(color: AppColors.textPrimary),
      bodySmall: AppTextStyles.text3.copyWith(color: AppColors.textPrimary),
      labelLarge: AppTextStyles.caption1.copyWith(
        color: AppColors.textSecondary,
      ),
      labelMedium: AppTextStyles.caption2.copyWith(
        color: AppColors.textSecondary,
      ),
      labelSmall: AppTextStyles.caption3.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // ==================== Button Theme ====================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.text1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.text1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.text1,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // ==================== Input Decoration ====================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderFocus, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.negative),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: AppTextStyles.text2.copyWith(color: AppColors.textTertiary),
      labelStyle: AppTextStyles.caption2.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // ==================== Card Theme ====================
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // ==================== Divider Theme ====================
    dividerTheme: DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
  );
}

// ==================== Dark Theme ====================
class _DarkTheme {
  _DarkTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // ==================== Color Scheme ====================
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surfaceDark,
      error: AppColors.negative,
    ),

    // ==================== Scaffold ====================
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // ==================== AppBar ====================
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: AppTextStyles.title2.copyWith(
        color: AppColors.textPrimaryDark,
      ),
    ),

    // ==================== Text Theme ====================
    textTheme: TextTheme(
      displayLarge: AppTextStyles.title1.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      displayMedium: AppTextStyles.title2.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      displaySmall: AppTextStyles.title3.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      headlineLarge: AppTextStyles.title1.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      headlineMedium: AppTextStyles.title2.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      headlineSmall: AppTextStyles.title3.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: AppTextStyles.text1.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: AppTextStyles.text2.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodySmall: AppTextStyles.text3.copyWith(color: AppColors.textPrimaryDark),
      labelLarge: AppTextStyles.caption1.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      labelMedium: AppTextStyles.caption2.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      labelSmall: AppTextStyles.caption3.copyWith(
        color: AppColors.textSecondaryDark,
      ),
    ),

    // ==================== Button Theme ====================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.text1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.text1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.text1,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // ==================== Input Decoration ====================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderFocus, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.negative),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: AppTextStyles.text2.copyWith(
        color: AppColors.textTertiaryDark,
      ),
      labelStyle: AppTextStyles.caption2.copyWith(
        color: AppColors.textSecondaryDark,
      ),
    ),

    // ==================== Card Theme ====================
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // ==================== Divider Theme ====================
    dividerTheme: DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
  );
}
