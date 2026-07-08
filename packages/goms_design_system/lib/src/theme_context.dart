import 'package:flutter/material.dart';
import 'package:goms_design_system/src/colors/app_colors.dart';

extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  bool get isDarkMode => theme.brightness == Brightness.dark;

  bool get isLightMode => theme.brightness == Brightness.light;

  Color get mainTextColor =>
      isDarkMode ? AppColors.mainTextDark : AppColors.mainText;

  Color get sub1Color => isDarkMode ? AppColors.sub1Dark : AppColors.sub1;

  Color get sub2Color => isDarkMode ? AppColors.sub2Dark : AppColors.sub2;

  Color get surfaceColor =>
      isDarkMode ? AppColors.bgSurfaceDark : AppColors.bgSurface;

  Color get backgroundColor =>
      isDarkMode ? AppColors.backgroundDark : AppColors.background;

  Color get buttonColor => isDarkMode ? AppColors.buttonDark : AppColors.button;

  Color get mapContainerColor =>
      isDarkMode ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;
}
