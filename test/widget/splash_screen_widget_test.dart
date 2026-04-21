import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/session/ui/providers/session_provider.dart';
import 'package:goms/features/member/ui/models/current_member_model.dart';
import 'package:goms/features/member/ui/providers/current_member_provider.dart';
import 'package:goms/features/splash/ui/screens/splash_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const permissionChannel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, (call) async {
      if (call.method == 'checkPermissionStatus') {
        return 0;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, null);
  });

  testWidgets(
    'SplashScreen waits for delayed token refresh before routing home',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(_DelayedAuthenticatedAuthNotifier.new),
          currentMemberProvider.overrideWith(_FakeCurrentMemberNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: RoutePath.splash,
        routes: [
          GoRoute(
            path: RoutePath.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: RoutePath.home,
            builder: (context, state) =>
                const Scaffold(body: Text('home-screen')),
          ),
          GoRoute(
            path: RoutePath.onboarding,
            builder: (context, state) =>
                const Scaffold(body: Text('onboarding-screen')),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: const [
                Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
                Breakpoint(start: 360, end: 450, name: 'MOBILE'),
                Breakpoint(start: 451, end: 800, name: 'TABLET'),
                Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
                Breakpoint(
                  start: 1921,
                  end: double.infinity,
                  name: '4K',
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 11));
      await tester.pumpAndSettle();

      expect(find.text('home-screen'), findsOneWidget);
      expect(find.text('onboarding-screen'), findsNothing);
    },
  );
}

class _DelayedAuthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthStatus build() => AuthStatus.checking;

  @override
  Future<bool> checkToken() async {
    await Future<void>.delayed(const Duration(seconds: 9));
    state = AuthStatus.authenticated;
    return true;
  }
}

class _FakeCurrentMemberNotifier extends CurrentMemberNotifier {
  @override
  Future<CurrentMemberModel?> build() async => const CurrentMemberModel(
        memberId: 1,
        email: 's24068@gsm.hs.kr',
        name: '이주언',
        role: RoleEnum.user,
        grade: 8,
        department: DepartmentType.ai,
      );
}
