import 'package:flutter/material.dart';
import 'config/dark_theme.dart';
import 'config/light_theme.dart';

/// 앱 테마 설정
class AppTheme {
  AppTheme._();

  /// 라이트 테마
  static ThemeData get light => LightTheme.theme;

  /// 다크 테마
  static ThemeData get dark => DarkTheme.theme;
}
