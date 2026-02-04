import 'package:flutter/material.dart';

/// 앱 컬러 시스템
class AppColors {
  AppColors._();

  // ==================== Primary Colors ====================
  /// 메인 컬러
  static const Color primary = Color(0xFFFFA500);

  /// Admin 컬러
  static const Color admin = Color(0xFFB486F9);

  /// Negative 컬러
  static const Color negative = Color(0xFFE23A24);

  // ==================== Background Colors ====================
  /// 배경색 (Light Mode)
  static const Color background = Color(0xFFFAFAFA);

  /// 표면색
  static const Color surface = Color(0xFFF7F7F8);

  /// 다크 모드 배경색
  static const Color backgroundDark = Color(0xFF0D0D0D);

  /// 다크 모드 표면색
  static const Color surfaceDark = Color(0xFF191919);

  // ==================== Text Colors ====================
  /// 기본 텍스트 색상 (Main text Light)
  static const Color textPrimary = Color(0xFF494949);

  /// sub-1 텍스트 색상
  static const Color textSecondary = Color(0xFF737373);

  /// sub-2 텍스트 색상
  static const Color textTertiary = Color(0xFF969696);

  /// 버튼 텍스트 색상
  static const Color textButton = Color(0xFFCACACA);

  /// 다크 모드 기본 텍스트
  static const Color textPrimaryDark = Color(0xFFFAFAFA);

  /// 다크 모드 sub-1
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  /// 다크 모드 sub-2
  static const Color textTertiaryDark = Color(0xFF5F5F5F);

  /// 다크 모드 버튼 텍스트
  static const Color textButtonDark = Color(0xFF343434);

  // ==================== Border Colors ====================
  /// 기본 테두리 색상
  static const Color border = Color(0xFFCACACA);

  /// 포커스 테두리 색상
  static const Color borderFocus = Color(0xFFFF9505);

  // ==================== Utility Colors ====================
  /// 투명
  static const Color transparent = Colors.transparent;

  /// 흰색
  static const Color white = Color(0xFFFFFFFF);

  /// 검은색
  static const Color black = Color(0xFF000000);

  /// 배경색 (사용 중단 예정 - background 사용)
  static const Color backgroundColor = Color(0xFFFAFAFA);
}
