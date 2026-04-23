import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/qr/ui/screens/outing_start_screen.dart';
import 'package:goms/features/qr/ui/screens/return_success_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('외출 성공 화면 확인 버튼은 콜백을 호출한다', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
            Breakpoint(start: 360, end: 450, name: 'MOBILE'),
            Breakpoint(start: 451, end: 800, name: 'TABLET'),
            Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
          ],
        ),
        home: OutingStartScreen(
          onConfirm: () {
            tapped = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('복귀 성공 화면 기본 확인 버튼은 홈으로 이동한다', (tester) async {
    final router = GoRouter(
      initialLocation: '/return-success',
      routes: [
        GoRoute(
          path: '/return-success',
          builder: (context, state) => const ReturnSuccessScreen(),
        ),
        GoRoute(
          path: RoutePath.home,
          builder: (context, state) =>
              const Scaffold(body: Text('home-screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
            Breakpoint(start: 360, end: 450, name: 'MOBILE'),
            Breakpoint(start: 451, end: 800, name: 'TABLET'),
            Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
          ],
        ),
      ),
    );

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(find.text('home-screen'), findsOneWidget);
  });

  testWidgets('복귀 성공 화면 확인 버튼은 콜백을 호출한다', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
            Breakpoint(start: 360, end: 450, name: 'MOBILE'),
            Breakpoint(start: 451, end: 800, name: 'TABLET'),
            Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
          ],
        ),
        home: ReturnSuccessScreen(
          onConfirm: () {
            tapped = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
