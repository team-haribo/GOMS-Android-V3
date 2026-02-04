import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 앱 아이콘 시스템
class AppIcons {
  AppIcons._();

  // ==================== SVG Icons ====================

  /// 금지된 원형 아이콘
  static Widget bannedCircle({double? width, double? height, Color? color}) =>
      SvgPicture.asset(
        'assets/icons/banned_circle.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );

  /// 복귀 성공 아이콘
  static Widget comeBackSuccess({
    double? width,
    double? height,
    Color? color,
  }) => SvgPicture.asset(
    'assets/icons/come_back_success.svg',
    width: width,
    height: height,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );

  /// 에러 원형 아이콘
  static Widget errorCircle({double? width, double? height, Color? color}) =>
      SvgPicture.asset(
        'assets/icons/error_circle.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );

  /// 로고 원형 아이콘
  static Widget logoCircle({double? width, double? height, Color? color}) =>
      SvgPicture.asset(
        'assets/icons/logo_circle.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );

  /// 로고 사각형 아이콘
  static Widget logoSquare({double? width, double? height, Color? color}) =>
      SvgPicture.asset(
        'assets/icons/logo_square.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );

  /// 프로필 원형 아이콘
  static Widget profileCircle({double? width, double? height, Color? color}) =>
      SvgPicture.asset(
        'assets/icons/profile_circle.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );

  /// 프로필 사각형 아이콘
  static Widget profileSquare({double? width, double? height, Color? color}) =>
      SvgPicture.asset(
        'assets/icons/profile_square.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );

  /// 성공 원형 아이콘
  static Widget successCircle({double? width, double? height, Color? color}) =>
      SvgPicture.asset(
        'assets/icons/success_circle.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );
}
