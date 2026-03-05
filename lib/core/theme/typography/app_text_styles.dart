import 'package:flutter/material.dart';

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
