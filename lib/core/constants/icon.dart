import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 앱 아이콘 관리
class AppIcons {
  AppIcons._();

  static const String _basePath = 'assets/icons';

  // Logo
  static Widget logoSmall({double size = 24}) =>
      SvgPicture.asset('$_basePath/logo_small.svg', width: size, height: size);

  static Widget logoCircle({double size = 24}) =>
      SvgPicture.asset('$_basePath/logo_circle.svg', width: size, height: size);

  static Widget logoSquare({double size = 24}) =>
      SvgPicture.asset('$_basePath/logo_square.svg', width: size, height: size);

  // Navigation
  static Widget home({double size = 24}) =>
      SvgPicture.asset('$_basePath/home.svg', width: size, height: size);

  static Widget user({double size = 24}) =>
      SvgPicture.asset('$_basePath/user.svg', width: size, height: size);

  static Widget map({double size = 24}) =>
      SvgPicture.asset('$_basePath/map.svg', width: size, height: size);

  // Profile
  static Widget profileCircle({double size = 24}) => SvgPicture.asset(
    '$_basePath/profile_circle.svg',
    width: size,
    height: size,
  );

  static Widget profileSquare({double size = 24}) => SvgPicture.asset(
    '$_basePath/profile_square.svg',
    width: size,
    height: size,
  );

  // QR Code
  static Widget qrCodeScan({double size = 24}) => SvgPicture.asset(
    '$_basePath/qr_code_scan.svg',
    width: size,
    height: size,
  );

  static Widget qrCodeLoad({double size = 24}) => SvgPicture.asset(
    '$_basePath/qr_code_load.svg',
    width: size,
    height: size,
  );

  // Status Icons (PNG)
  static Widget successCircle({double size = 24}) =>
      Image.asset('$_basePath/success_circle.png', width: size, height: size);

  static Widget errorCircle({double size = 24}) =>
      Image.asset('$_basePath/error_circle.png', width: size, height: size);

  static Widget bannedCircle({double size = 24}) =>
      Image.asset('$_basePath/banned_circle.png', width: size, height: size);

  static Widget comeBackSuccess({double size = 24}) => Image.asset(
    '$_basePath/come_back_success.png',
    width: size,
    height: size,
  );
}
