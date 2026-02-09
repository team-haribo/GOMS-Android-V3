import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 앱 아이콘 시스템
class AppIcons {
  AppIcons._();

  // ==================== Private Helper Methods ====================

  /// SVG 아이콘 로드 헬퍼
  static Widget _loadSvg(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) => SvgPicture.asset(
    assetPath,
    width: width,
    height: height,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );

  /// PNG 아이콘 로드 헬퍼
  static Widget _loadPng(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) => Image.asset(assetPath, width: width, height: height, color: color);

  // ==================== PNG Icons ====================

  /// 금지된 원형 아이콘
  static Widget bannedCircle({double? width, double? height, Color? color}) =>
      _loadPng(
        'assets/icons/banned_circle.png',
        width: width,
        height: height,
        color: color,
      );

  /// 복귀 성공 아이콘
  static Widget comeBackSuccess({
    double? width,
    double? height,
    Color? color,
  }) => _loadPng(
    'assets/icons/come_back_success.png',
    width: width,
    height: height,
    color: color,
  );

  /// 에러 원형 아이콘
  static Widget errorCircle({double? width, double? height, Color? color}) =>
      _loadPng(
        'assets/icons/error_circle.png',
        width: width,
        height: height,
        color: color,
      );

  /// 성공 원형 아이콘
  static Widget successCircle({double? width, double? height, Color? color}) =>
      _loadPng(
        'assets/icons/success_circle.png',
        width: width,
        height: height,
        color: color,
      );

  // ==================== SVG Icons ====================

  /// 로고 원형 아이콘
  static Widget logoCircle({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/logo_circle.svg',
        width: width,
        height: height,
        color: color,
      );

  /// 로고 사각형 아이콘
  static Widget logoSquare({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/logo_square.svg',
        width: width,
        height: height,
        color: color,
      );

  /// 프로필 원형 아이콘
  static Widget profileCircle({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/profile_circle.svg',
        width: width,
        height: height,
        color: color,
      );

  /// 프로필 사각형 아이콘
  static Widget profileSquare({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/profile_square.svg',
        width: width,
        height: height,
        color: color,
      );

  /// 홈 아이콘
  static Widget home({double? width, double? height, Color? color}) => _loadSvg(
    'assets/icons/home.svg',
    width: width,
    height: height,
    color: color,
  );

  /// 지도 아이콘
  static Widget map({double? width, double? height, Color? color}) => _loadSvg(
    'assets/icons/map.svg',
    width: width,
    height: height,
    color: color,
  );

  /// 사용자 아이콘
  static Widget user({double? width, double? height, Color? color}) => _loadSvg(
    'assets/icons/user.svg',
    width: width,
    height: height,
    color: color,
  );
}
