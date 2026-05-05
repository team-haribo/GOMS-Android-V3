import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppBreakpoints {
  AppBreakpoints._();

  static const String smallPhone = 'SMALL_PHONE';
  static const String mobile = MOBILE;
  static const String tablet = TABLET;
  static const String desktop = DESKTOP;
  static const String largeDesktop = '4K';
}

class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s36 = 36;
  static const double s52 = 52;
  static const double s182 = 182;
  static const double s190 = 190;
}

class AppGap {
  static const SizedBox h2 = SizedBox(width: AppSpacing.s2);
  static const SizedBox v2 = SizedBox(height: AppSpacing.s2);
  static const SizedBox h4 = SizedBox(width: AppSpacing.s4);
  static const SizedBox v4 = SizedBox(height: AppSpacing.s4);
  static const SizedBox h8 = SizedBox(width: AppSpacing.s8);
  static const SizedBox v8 = SizedBox(height: AppSpacing.s8);
  static const SizedBox h12 = SizedBox(width: AppSpacing.s12);
  static const SizedBox v12 = SizedBox(height: AppSpacing.s12);
  static const SizedBox h14 = SizedBox(width: AppSpacing.s14);
  static const SizedBox v14 = SizedBox(height: AppSpacing.s14);
  static const SizedBox h16 = SizedBox(width: AppSpacing.s16);
  static const SizedBox v16 = SizedBox(height: AppSpacing.s16);
  static const SizedBox h20 = SizedBox(width: AppSpacing.s20);
  static const SizedBox v20 = SizedBox(height: AppSpacing.s20);
  static const SizedBox h24 = SizedBox(width: AppSpacing.s24);
  static const SizedBox v24 = SizedBox(height: AppSpacing.s24);
  static const SizedBox h36 = SizedBox(width: AppSpacing.s36);
  static const SizedBox v36 = SizedBox(height: AppSpacing.s36);
  static const SizedBox h52 = SizedBox(width: AppSpacing.s52);
  static const SizedBox v52 = SizedBox(height: AppSpacing.s52);
  static const SizedBox h182 = SizedBox(width: AppSpacing.s182);
  static const SizedBox v182 = SizedBox(height: AppSpacing.s182);
  static const SizedBox h190 = SizedBox(width: AppSpacing.s190);
  static const SizedBox v190 = SizedBox(height: AppSpacing.s190);
}

class AppPadding {
  static const EdgeInsets screenVertical = EdgeInsets.symmetric(
    vertical: 11.5,
  );
}

extension ResponsiveLayoutX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  double get phoneScale {
    final scale = screenWidth / 390;
    return scale.clamp(0.9, 1.08).toDouble();
  }

  bool get isCompactLayout =>
      ResponsiveBreakpoints.of(this).smallerOrEqualTo(AppBreakpoints.mobile);

  bool get isTabletLayout =>
      ResponsiveBreakpoints.of(this).largerThan(AppBreakpoints.mobile) &&
      ResponsiveBreakpoints.of(this).smallerOrEqualTo(AppBreakpoints.tablet);

  bool get isDesktopLayout =>
      ResponsiveBreakpoints.of(this).largerThan(AppBreakpoints.tablet);

  bool get isSmallPhoneLayout =>
      ResponsiveBreakpoints.of(this).equals(AppBreakpoints.smallPhone) ||
      screenWidth < 360;

  double get spacingScale {
    if (isDesktopLayout) return 1.12;
    if (isTabletLayout) return 1.08;
    return phoneScale.clamp(0.92, 1.06).toDouble();
  }

  double get typographyScale {
    if (isDesktopLayout) return 1.08;
    if (isTabletLayout) return 1.04;
    return phoneScale.clamp(0.94, 1.05).toDouble();
  }

  double get horizontalPadding {
    if (isDesktopLayout) return 32;
    if (isTabletLayout) return 28;
    if (isSmallPhoneLayout) return scaled(14);
    if (isCompactLayout) return scaled(16);
    return scaled(24);
  }

  double get verticalPadding {
    if (isTabletLayout) return 28;
    if (isSmallPhoneLayout) return scaled(14);
    if (isCompactLayout) return scaled(16);
    return scaled(24);
  }

  double get contentMaxWidth {
    if (isDesktopLayout) return 960;
    if (isTabletLayout) return 720;
    return double.infinity;
  }

  double scaled(
    double value, {
    double minFactor = 0.9,
    double maxFactor = 1.08,
  }) {
    final scale = phoneScale.clamp(minFactor, maxFactor).toDouble();
    return value * scale;
  }

  double responsive({
    required double compact,
    required double normal,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktopLayout) return desktop ?? tablet ?? normal;
    if (isTabletLayout) return tablet ?? normal;
    if (isSmallPhoneLayout) return scaled(compact, minFactor: 0.88);
    if (isCompactLayout) return scaled(compact);
    return scaled(normal);
  }

  double space(double value) => value * spacingScale;

  SizedBox hSpace(double value) => SizedBox(width: space(value));

  SizedBox vSpace(double value) => SizedBox(height: space(value));

  EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      );
}
