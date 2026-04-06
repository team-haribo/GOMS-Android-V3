import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/auth/session/presentation/providers/session_provider.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';
import 'package:goms/features/profile/presentation/screens/my_page_screen.dart';
import 'package:goms/features/profile/presentation/providers/settings_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('MyPageScreen connects top profile summary to real outing data',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
          themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
          settingsProvider.overrideWith(_FakeSettingsNotifier.new),
          myOutingStatusProvider.overrideWith(_FakeMyOutingStatusNotifier.new),
        ],
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
          home: const MyPageScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('이주언'), findsOneWidget);
    expect(find.text('8기 | AI과'), findsOneWidget);
    expect(find.text('지각 횟수'), findsOneWidget);
    expect(find.text('3번'), findsOneWidget);
  });

  testWidgets('MyPageScreen logout confirm closes dialog and routes to onboarding',
      (tester) async {
    final authNotifier = _FakeAuthNotifier();
    final container = ProviderContainer(
      overrides: [
        roleProvider.overrideWith((ref) => RoleEnum.user),
        themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
        settingsProvider.overrideWith(_FakeSettingsNotifier.new),
        myOutingStatusProvider.overrideWith(_FakeMyOutingStatusNotifier.new),
        currentMemberProvider.overrideWith(_FakeCurrentMemberNotifier.new),
        authProvider.overrideWith(() => authNotifier),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: RoutePath.myPage,
      routes: [
        GoRoute(
          path: RoutePath.myPage,
          builder: (context, state) => const MyPageScreen(),
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

    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('로그아웃'));
    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();

    expect(find.text('로그아웃 하시겠습니까?'), findsOneWidget);

    await tester.tap(find.text('로그아웃').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(authNotifier.logoutCallCount, 1);
    expect(find.text('onboarding-screen'), findsOneWidget);
  });
}

class _FakeThemeModeNotifier extends ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async => ThemeMode.system;
}

class _FakeSettingsNotifier extends SettingsNotifier {
  @override
  Future<SettingsState> build() async => const SettingsState(
        showClock: false,
        outingPushAlarm: true,
        cameraLaunch: false,
      );
}

class _FakeMyOutingStatusNotifier extends MyOutingStatusNotifier {
  @override
  Future<MyOutingStatusEntity> build() async => const MyOutingStatusEntity(
        memberId: 1,
        status: OutingStatusType.outing,
        name: '이주언',
        grade: 8,
        department: 'AI',
        lateCount: 3,
      );
}

class _FakeCurrentMemberNotifier extends CurrentMemberNotifier {
  @override
  Future<CurrentMemberEntity?> build() async => const CurrentMemberEntity(
        memberId: 1,
        email: 's24068@gsm.hs.kr',
        name: '이주언',
        role: RoleEnum.user,
      );
}

class _FakeAuthNotifier extends AuthNotifier {
  int logoutCallCount = 0;

  @override
  AuthStatus build() => AuthStatus.authenticated;

  @override
  Future<void> logout() async {
    logoutCallCount++;
    state = AuthStatus.unauthenticated;
  }
}
