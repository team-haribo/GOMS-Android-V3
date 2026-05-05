import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/auth/login/ui/screens/login_screen.dart';
import 'package:goms/features/splash/ui/screens/onboarding_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('onboarding login button opens login screen without exceptions', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: RoutePath.onboarding,
      routes: [
        GoRoute(
          path: RoutePath.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: RoutePath.login,
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: router,
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
        ),
      ),
    );
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('비밀번호 찾기'), findsOneWidget);
  });
}
