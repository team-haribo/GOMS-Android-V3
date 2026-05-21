import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';
import 'package:goms/features/profile/presentation/viewmodels/settings_viewmodel.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';
import 'package:goms/features/profile/presentation/screens/my_page_screen.dart';
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
          currentMemberProvider.overrideWith(_FakeCurrentMemberNotifier.new),
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
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('3') &&
            widget.text.toPlainText().contains('번'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('MyPageScreen scrolls before profile content overflows',
      (tester) async {
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
          themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
          settingsProvider.overrideWith(_FakeSettingsNotifier.new),
          myOutingStatusProvider.overrideWith(_FakeMyOutingStatusNotifier.new),
          currentMemberProvider.overrideWith(_FakeCurrentMemberNotifier.new),
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

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'MyPageScreen logout confirm closes dialog and routes to onboarding',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

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

    expect(find.byType(SingleChildScrollView), findsNothing);

    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();

    expect(find.text('\n 로그아웃 하시겠습니까?'), findsOneWidget);

    await tester.tap(find.text('로그아웃').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(authNotifier.logoutCallCount, 1);
    expect(find.text('onboarding-screen'), findsOneWidget);
  });

  testWidgets('MyPageScreen shows admin QR auto open setting only',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        roleProvider.overrideWith((ref) => RoleEnum.admin),
        themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
        settingsProvider.overrideWith(_FakeSettingsNotifier.new),
        myOutingStatusProvider.overrideWith(_FakeMyOutingStatusNotifier.new),
        currentMemberProvider.overrideWith(_FakeCurrentMemberNotifier.new),
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

    expect(find.text('외출제 푸시 알림'), findsNothing);
    expect(find.text('QR 생성 바로 켜기'), findsOneWidget);

    final lastSettingBottom = tester.getBottomLeft(find.text('QR 생성 바로 켜기')).dy;
    final firstActionTop = tester.getTopLeft(find.text('비밀번호 재설정')).dy;

    expect(firstActionTop - lastSettingBottom, lessThan(120));
    expect(
      find.ancestor(
        of: find.text('비밀번호 재설정'),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Padding &&
              widget.padding ==
                  const EdgeInsets.symmetric(vertical: AppSpacing.s16),
        ),
      ),
      findsOneWidget,
    );

    final accountDivider = find.byType(Divider).last;
    final firstActionRow = find
        .ancestor(
          of: find.text('비밀번호 재설정'),
          matching: find.byType(InkWell),
        )
        .first;
    expect(
      tester.getTopLeft(firstActionRow).dy -
          tester.getBottomLeft(accountDivider).dy,
      AppSpacing.s24,
    );
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
        grade: 8,
        department: DepartmentType.ai,
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
