import 'package:flutter/material.dart';
import 'package:goms/core/theme/layout/app_layout.dart';

/// 앱 텍스트 스타일 시스템
class AppTextStyles {
  AppTextStyles._();

  // ==================== Font Family ====================
  /// 기본 폰트
  static const String defaultFontFamily = 'suit';

  // ==================== Title Styles ====================
  /// profile container dateTime 폰트
  static const TextStyle dateTimeAmPm = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle dateTime = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w900,
  );

  /// Title-1 (Bold, 24px)
  static const TextStyle title1 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
  );

  /// Title-2 (Semibold, 20px)
  static const TextStyle title2 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // Semibold
  );

  /// Title-3 (Semibold, 18px)
  static const TextStyle title3 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // Semibold
  );

  // ==================== Text Styles ====================
  /// Text-1 (Semibold, 16px)
  static const TextStyle text1 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semibold
  );

  /// Text-2 (Medium, 16px)
  static const TextStyle text2 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
  );

  /// Text-3 (Medium, 15px)
  static const TextStyle text3 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500, // Medium
  );

  // ==================== Caption Styles ====================
  /// Caption-1 (Medium, 14px)
  static const TextStyle caption1 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
  );

  /// Caption-2 (Medium, 13px)
  static const TextStyle caption2 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500, // Medium
  );

  /// Caption-3 (Medium, 12px)
  static const TextStyle caption3 = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
  );
}

// ==================== TextStyle Extensions ====================
/// TextStyle 확장 메서드
extension TextStyleExtensions on TextStyle {
  /// 색상 변경
  TextStyle withColor(Color color) => copyWith(color: color);

  /// 폰트 굵기 변경
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);

  /// 폰트 크기 변경
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

class AppTypographyData {
  const AppTypographyData._({
    required this.dateTimeAmPm,
    required this.dateTime,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.caption1,
    required this.caption2,
    required this.caption3,
  });

  factory AppTypographyData.scaled(double scale) {
    TextStyle resize(TextStyle style) =>
        style.copyWith(fontSize: (style.fontSize ?? 14) * scale);

    return AppTypographyData._(
      dateTimeAmPm: resize(AppTextStyles.dateTimeAmPm),
      dateTime: resize(AppTextStyles.dateTime),
      title1: resize(AppTextStyles.title1),
      title2: resize(AppTextStyles.title2),
      title3: resize(AppTextStyles.title3),
      text1: resize(AppTextStyles.text1),
      text2: resize(AppTextStyles.text2),
      text3: resize(AppTextStyles.text3),
      caption1: resize(AppTextStyles.caption1),
      caption2: resize(AppTextStyles.caption2),
      caption3: resize(AppTextStyles.caption3),
    );
  }

  final TextStyle dateTimeAmPm;
  final TextStyle dateTime;
  final TextStyle title1;
  final TextStyle title2;
  final TextStyle title3;
  final TextStyle text1;
  final TextStyle text2;
  final TextStyle text3;
  final TextStyle caption1;
  final TextStyle caption2;
  final TextStyle caption3;
}

extension AppTypographyContextX on BuildContext {
  AppTypographyData get appTypography =>
      AppTypographyData.scaled(typographyScale);
}
