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
  }) =>
      SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );

  /// PNG 아이콘 로드 헬퍼
  static Widget _loadPng(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) =>
      Image.asset(assetPath, width: width, height: height, color: color);

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
  static Widget comeBackSuccessCircle({
    double? width,
    double? height,
    Color? color,
  }) =>
      _loadPng(
        'assets/icons/comeback_success_circle.png',
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

  /// 외출 성공 원형 아이콘
  static Widget outingSuccess({double? width, double? height, Color? color}) =>
      _loadPng(
        'assets/icons/OutingSuccess.png',
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

  /// 로고 작은 아이콘
  static Widget logoSmall({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/logo_small.svg',
        width: width ?? 24,
        height: height ?? 24,
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

  /// GOMS 로고 (큰 로고)
  static Widget gomsLogo({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/goms_logo.svg',
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

  /// QR 코드 로드 아이콘
  static Widget qrCodeLoad({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/qr_code_load.svg',
        width: width,
        height: height,
        color: color,
      );

  /// QR 코드 스캔 아이콘
  static Widget qrCodeScan({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/qr_code_scan.svg',
        width: width,
        height: height,
        color: color,
      );

  /// 지도 즐겨찾기 하트 아이콘
  static Widget heart({double? width, double? height, Color? color}) =>
      _loadPng(
        'assets/icons/heart.png',
        width: width,
        height: height,
        color: color,
      );

  static Widget heartFilled({double? width, double? height, Color? color}) =>
      _loadPng(
        'assets/icons/heart_filled.png',
        width: width,
        height: height,
        color: color,
      );

  /// 지도 댓글 삭제 아이콘
  static Widget bin({double? width, double? height, Color? color}) => _loadPng(
        'assets/icons/bin.png',
        width: width,
        height: height,
        color: color,
      );


  /// 지각자 없을 때 아이콘
  static Widget fire({double? width, double? height, Color? color}) => _loadPng(
        'assets/icons/fire.png',
        width: width,
        height: height,
        color: color,
      );

  /// 앱바 돌아가기 아이콘
  static Widget back({double? width, double? height, Color? color}) => _loadPng(
        'assets/icons/back.png',
        width: width,
        height: height,
        color: color,
      );

  /// 외출하는 날이 아닐 때 뜨는 커피 아이콘
  static Widget coffee({double? width, double? height, Color? color}) =>
      _loadSvg(
        'assets/icons/coffee.svg',
          width: width,
          height: height,
          color: color,);

  /// 편집 아이콘
  static Widget edit({double? width, double? height, Color? color}) => _loadSvg(
        'assets/icons/edit_icon.svg',

        width: width,
        height: height,
        color: color,
      );

  /// 선택 취소 아이콘
  static Widget cancel({double? width, double? height, Color? color}) => _loadPng(
    'assets/icons/cancel.png',
    width: width,
    height: height,
    color: color,
  );

  /// 후기 남기기 아이콘
  static Widget tablerEdit({double? width, double? height, Color? color}) => _loadPng(
    'assets/icons/tabler_edit.png',
    width: width,
    height: height,
    color: color,
  );

  /// 신고 아이콘
  static Widget report({double? width, double? height, Color? color}) => _loadPng(
    'assets/icons/report.png',
    width: width,
    height: height,
    color: color,
  );
}