import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

/// 디자인 토큰 간격을 screenutil(.w/.h)로 스케일한 [SizedBox] 모음.
///
/// 가로 간격(hN)은 화면 폭, 세로 간격(vN)은 화면 높이 기준으로 비율 스케일된다.
/// const SizedBox에서 런타임 getter로 바뀌었으므로 const 컨텍스트에서는 사용할 수 없다.
class AppGap {
  AppGap._();

  static SizedBox get h2 => SizedBox(width: AppSpacing.s2.w);
  static SizedBox get v2 => SizedBox(height: AppSpacing.s2.h);
  static SizedBox get h4 => SizedBox(width: AppSpacing.s4.w);
  static SizedBox get v4 => SizedBox(height: AppSpacing.s4.h);
  static SizedBox get h8 => SizedBox(width: AppSpacing.s8.w);
  static SizedBox get v8 => SizedBox(height: AppSpacing.s8.h);
  static SizedBox get h12 => SizedBox(width: AppSpacing.s12.w);
  static SizedBox get v12 => SizedBox(height: AppSpacing.s12.h);
  static SizedBox get h14 => SizedBox(width: AppSpacing.s14.w);
  static SizedBox get v14 => SizedBox(height: AppSpacing.s14.h);
  static SizedBox get h16 => SizedBox(width: AppSpacing.s16.w);
  static SizedBox get v16 => SizedBox(height: AppSpacing.s16.h);
  static SizedBox get h20 => SizedBox(width: AppSpacing.s20.w);
  static SizedBox get v20 => SizedBox(height: AppSpacing.s20.h);
  static SizedBox get h24 => SizedBox(width: AppSpacing.s24.w);
  static SizedBox get v24 => SizedBox(height: AppSpacing.s24.h);
  static SizedBox get h36 => SizedBox(width: AppSpacing.s36.w);
  static SizedBox get v36 => SizedBox(height: AppSpacing.s36.h);
  static SizedBox get h52 => SizedBox(width: AppSpacing.s52.w);
  static SizedBox get v52 => SizedBox(height: AppSpacing.s52.h);
  static SizedBox get h182 => SizedBox(width: AppSpacing.s182.w);
  static SizedBox get v182 => SizedBox(height: AppSpacing.s182.h);
  static SizedBox get h190 => SizedBox(width: AppSpacing.s190.w);
  static SizedBox get v190 => SizedBox(height: AppSpacing.s190.h);
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
