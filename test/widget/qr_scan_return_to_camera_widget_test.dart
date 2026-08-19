import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/qr/presentation/screens/qr_scan_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// #122 회귀 테스트.
///
/// 실패 결과 화면의 "카메라로 돌아가기"가 `context.go(RoutePath.qr)`였을 때는
/// 스택 전체가 `/qr` 하나로 교체돼, go_router가 같은 pageKey로 스캔 화면을
/// 재사용하면서 `initState`가 다시 돌지 않았다. 멈춰둔 카메라도 그대로 남았다.
/// 이제는 pop으로 돌아가므로 스캔 화면 아래의 라우트가 살아남아야 한다.
void main() {
  testWidgets('QR 실패 화면에서 카메라로 돌아가면 스캔 화면 아래 스택이 유지된다', (tester) async {
    final router = GoRouter(
      initialLocation: RoutePath.home,
      routes: [
        GoRoute(
          path: RoutePath.home,
          builder: (context, state) => const Scaffold(body: Text('home-screen')),
        ),
        GoRoute(
          path: RoutePath.qr,
          builder: (context, state) => const Scaffold(body: Text('scan-screen')),
        ),
        GoRoute(
          path: RoutePath.qrResult,
          builder: (context, state) => buildQrScanResultRouteScreen(
            state.pathParameters['resultType'],
            context: context,
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

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
    await tester.pumpAndSettle();

    // 홈 -> 스캔 -> 실패 결과. 실제 흐름과 같이 둘 다 push로 쌓는다.
    router.push(RoutePath.qr);
    await tester.pumpAndSettle();
    router.push(RoutePath.qrResultLocation('failure'));
    await tester.pumpAndSettle();
    expect(find.text('외출에 실패했어요..'), findsOneWidget);

    await tester.tap(find.text('카메라로 돌아가기'));
    await tester.pumpAndSettle();

    expect(find.text('scan-screen'), findsOneWidget);
    // go로 교체됐다면 스택이 [/qr] 하나만 남아 canPop()이 false가 된다.
    expect(router.canPop(), isTrue);
  });

  testWidgets('스캔 화면 없이 실패 화면에 바로 진입하면 스캔 화면으로 이동한다', (tester) async {
    final router = GoRouter(
      initialLocation: RoutePath.qrResultLocation('failure'),
      routes: [
        GoRoute(
          path: RoutePath.qr,
          builder: (context, state) => const Scaffold(body: Text('scan-screen')),
        ),
        GoRoute(
          path: RoutePath.qrResult,
          builder: (context, state) => buildQrScanResultRouteScreen(
            state.pathParameters['resultType'],
            context: context,
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

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
    await tester.pumpAndSettle();

    await tester.tap(find.text('카메라로 돌아가기'));
    await tester.pumpAndSettle();

    expect(find.text('scan-screen'), findsOneWidget);
  });
}
