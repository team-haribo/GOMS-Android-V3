import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/widgets/goms_bottom_navigation.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('GomsBottomNavigation does not overflow with bottom insets', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2340));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(1080, 2340),
          padding: EdgeInsets.only(bottom: 66),
          viewPadding: EdgeInsets.only(bottom: 66),
          viewInsets: EdgeInsets.zero,
        ),
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
              Breakpoint(
                start: 1921,
                end: double.infinity,
                name: AppBreakpoints.largeDesktop,
              ),
            ],
          ),
          home: Scaffold(
            bottomNavigationBar: GomsBottomNavigation(
              currentIndex: 1,
              onTap: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
