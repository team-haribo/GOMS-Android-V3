/// 앱 아이콘 경로 관리
class AppIcons {
  AppIcons._();

  static const String _basePath = 'assets/icons';

  // Logo
  static const String logoSmall = '$_basePath/logo_small.svg';
  static const String logoCircle = '$_basePath/logo_circle.svg';
  static const String logoSquare = '$_basePath/logo_square.svg';

  // Navigation
  static const String home = '$_basePath/home.svg';
  static const String user = '$_basePath/user.svg';
  static const String map = '$_basePath/map.svg';

  // Profile
  static const String profileCircle = '$_basePath/profile_circle.svg';
  static const String profileSquare = '$_basePath/profile_square.svg';

  // QR Code
  static const String qrCodeScan = '$_basePath/qr_code_scan.svg';
  static const String qrCodeLoad = '$_basePath/qr_code_load.svg';

  // Status Icons (PNG)
  static const String successCircle = '$_basePath/success_circle.png';
  static const String errorCircle = '$_basePath/error_circle.png';
  static const String bannedCircle = '$_basePath/banned_circle.png';
  static const String comeBackSuccess = '$_basePath/come_back_success.png';
}
