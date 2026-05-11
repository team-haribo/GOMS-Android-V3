import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/auth/session/ui/viewmodels/session_viewmodel.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_viewmodel.dart';
import 'package:goms/features/profile/presentation/viewmodels/settings_viewmodel.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/auth/email_verification/data/datasources/email_verification_remote_datasource.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/confirm_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/models/response/email_verification/confirm_email_verification_response_dto.dart';
import 'package:goms/features/auth/email_verification/data/providers/email_verification_data_providers.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/password_reset/data/datasources/password_reset_remote_datasource.dart';
import 'package:goms/features/auth/password_reset/data/providers/password_reset_data_providers.dart';
import 'package:goms/features/auth/password_reset/data/request/password/change_password_request_dto.dart';
import 'package:goms/features/auth/login/presentation/screens/login_screen.dart';
import 'package:goms/features/auth/password_reset/presentation/screens/reset_password_screen.dart';
import 'package:goms/features/auth/shared/presentation/routes/verify_route_extra.dart';
import 'package:goms/features/auth/verification/presentation/screens/verify_screen.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';
import 'package:goms/features/profile/presentation/screens/my_page_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('password reset flow', () {
    testWidgets('MyPageScreen starts email verification before password reset',
        (tester) async {
      final repository = _FakePasswordResetRepository();
      final container = ProviderContainer(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
          themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
          settingsProvider.overrideWith(_FakeSettingsNotifier.new),
          myOutingStatusProvider.overrideWith(_FakeMyOutingStatusNotifier.new),
          currentMemberProvider.overrideWith(_FakeCurrentMemberNotifier.new),
          passwordResetRemoteDataSourceProvider.overrideWithValue(repository),
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
            path: RoutePath.verify,
            builder: (context, state) =>
                const Scaffold(body: Text('verify-screen')),
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
      await tester.ensureVisible(find.text('비밀번호 재설정'));
      await tester.tap(find.text('비밀번호 재설정'));
      await tester.pumpAndSettle();

      expect(repository.sentEmail, 's24068@gsm.hs.kr');
      expect(
        repository.sentPurpose,
        EmailVerificationPurpose.passwordChange,
      );
      expect(container.read(authFlowProvider).email, 's24068@gsm.hs.kr');
      expect(find.text('verify-screen'), findsOneWidget);
    });

    testWidgets('MyPageScreen verify back returns to my page', (tester) async {
      final repository = _FakePasswordResetRepository();
      final container = ProviderContainer(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
          themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
          settingsProvider.overrideWith(_FakeSettingsNotifier.new),
          myOutingStatusProvider.overrideWith(_FakeMyOutingStatusNotifier.new),
          currentMemberProvider.overrideWith(_FakeCurrentMemberNotifier.new),
          passwordResetRemoteDataSourceProvider.overrideWithValue(repository),
          authFlowProvider.overrideWith(_FakeResetFlowNotifier.new),
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
            path: RoutePath.verify,
            builder: (context, state) {
              final extra = state.extra;
              final routeExtra = switch (extra) {
                VerifyRouteExtra() => extra,
                String() => VerifyRouteExtra(redirectPath: extra),
                _ => const VerifyRouteExtra(),
              };

              return VerifyScreen(
                redirectPath: routeExtra.redirectPath,
                backPath: routeExtra.backPath,
              );
            },
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
      await tester.ensureVisible(find.text('비밀번호 재설정'));
      await tester.tap(find.text('비밀번호 재설정'));
      await tester.pumpAndSettle();

      expect(find.text('인증번호'), findsOneWidget);

      await tester.tap(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(TextButton),
            )
            .first,
      );
      await tester.pumpAndSettle();

      expect(find.text('비밀번호 재설정'), findsOneWidget);
      expect(find.text('인증번호'), findsNothing);
    });

    testWidgets(
        'ResetPasswordScreen redirects to verify when email check is incomplete',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          authFlowProvider.overrideWith(_FakeResetFlowNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: RoutePath.resetPassword,
        routes: [
          GoRoute(
            path: RoutePath.resetPassword,
            builder: (context, state) => const ResetPasswordScreen(),
          ),
          GoRoute(
            path: RoutePath.verify,
            builder: (context, state) =>
                const Scaffold(body: Text('verify-screen')),
          ),
          GoRoute(
            path: RoutePath.findPassword,
            builder: (context, state) =>
                const Scaffold(body: Text('find-password-screen')),
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

      expect(find.text('verify-screen'), findsOneWidget);
      expect(find.text('비밀번호 재설정'), findsNothing);
    });

    testWidgets(
        'ResetPasswordScreen logs out and returns to login after success',
        (tester) async {
      final repository = _FakePasswordResetRepository();
      final authNotifier = _FakeAuthNotifier();
      final container = ProviderContainer(
        overrides: [
          authFlowProvider.overrideWith(_FakeVerifiedResetFlowNotifier.new),
          passwordResetRemoteDataSourceProvider.overrideWithValue(repository),
          authProvider.overrideWith(() => authNotifier),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: RoutePath.resetPassword,
        routes: [
          GoRoute(
            path: RoutePath.resetPassword,
            builder: (context, state) => const ResetPasswordScreen(),
          ),
          GoRoute(
            path: RoutePath.login,
            builder: (context, state) =>
                const Scaffold(body: Text('login-screen')),
          ),
          GoRoute(
            path: RoutePath.findPassword,
            builder: (context, state) =>
                const Scaffold(body: Text('find-password-screen')),
          ),
          GoRoute(
            path: RoutePath.verify,
            builder: (context, state) =>
                const Scaffold(body: Text('verify-screen')),
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
      await tester.enterText(find.byType(TextFormField).at(0), 'Abc123!');
      await tester.enterText(find.byType(TextFormField).at(1), 'Abc123!');
      await tester.pumpAndSettle();

      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      expect(repository.changedEmail, 's24068@gsm.hs.kr');
      expect(repository.changedVerifiedToken, 'verified-token');
      expect(repository.changedPassword, 'Abc123!');
      expect(find.text('재설정 완료'), findsOneWidget);

      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(authNotifier.logoutCallCount, 1);
      expect(find.text('login-screen'), findsOneWidget);
    });

    testWidgets(
        'LoginScreen back button falls back to onboarding when opened as root',
        (tester) async {
      final router = GoRouter(
        initialLocation: RoutePath.login,
        routes: [
          GoRoute(
            path: RoutePath.login,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: RoutePath.onboarding,
            builder: (context, state) =>
                const Scaffold(body: Text('onboarding-screen')),
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
                Breakpoint(
                  start: 801,
                  end: 1920,
                  name: AppBreakpoints.desktop,
                ),
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

      await tester.tap(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(TextButton),
            )
            .first,
      );
      await tester.pumpAndSettle();

      expect(find.text('onboarding-screen'), findsOneWidget);
    });

    testWidgets('VerifyScreen shows snackbar when verification fails',
        (tester) async {
      final repository = _FakeEmailVerificationRepository(
        confirmException: DioException(
          requestOptions: RequestOptions(
            path: '/api/v3/auth/email-verifications/confirm',
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: '/api/v3/auth/email-verifications/confirm',
            ),
            statusCode: 400,
            data: {'message': '인증번호가 올바르지 않습니다.'},
          ),
        ),
      );
      final container = ProviderContainer(
        overrides: [
          authFlowProvider.overrideWith(_FakeResetFlowNotifier.new),
          emailVerificationRemoteDataSourceProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: ResponsiveBreakpoints.builder(
              child: const VerifyScreen(redirectPath: RoutePath.resetPassword),
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
      await tester.enterText(find.byType(TextFormField), '123456');
      await tester.pumpAndSettle();
      await tester.tap(find.text('인증'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('인증번호가 올바르지 않습니다.'), findsWidgets);

      container.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets(
        'VerifyScreen timer counts down and root back falls back to find password',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          authFlowProvider.overrideWith(_FakeResetFlowNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: RoutePath.verify,
        routes: [
          GoRoute(
            path: RoutePath.verify,
            builder: (context, state) =>
                const VerifyScreen(redirectPath: RoutePath.resetPassword),
          ),
          GoRoute(
            path: RoutePath.findPassword,
            builder: (context, state) =>
                const Scaffold(body: Text('find-password-screen')),
          ),
          GoRoute(
            path: RoutePath.signUp,
            builder: (context, state) =>
                const Scaffold(body: Text('signup-screen')),
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

      await tester.pump();
      expect(find.text('05:00'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('04:59'), findsOneWidget);

      await tester.tap(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(TextButton),
            )
            .first,
      );
      await tester.pumpAndSettle();

      expect(find.text('find-password-screen'), findsOneWidget);
    });

    testWidgets(
        'VerifyScreen back in reset flow always routes to find password',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          authFlowProvider.overrideWith(_FakeResetFlowNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: RoutePath.resetPassword,
        routes: [
          GoRoute(
            path: RoutePath.resetPassword,
            builder: (context, state) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => context.push(
                    RoutePath.verify,
                    extra: RoutePath.resetPassword,
                  ),
                  child: const Text('open-verify'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: RoutePath.verify,
            builder: (context, state) => VerifyScreen(
              redirectPath: state.extra as String?,
            ),
          ),
          GoRoute(
            path: RoutePath.findPassword,
            builder: (context, state) =>
                const Scaffold(body: Text('find-password-screen')),
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
      await tester.tap(find.text('open-verify'));
      await tester.pumpAndSettle();

      await tester.tap(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(TextButton),
            )
            .first,
      );
      await tester.pumpAndSettle();

      expect(find.text('find-password-screen'), findsOneWidget);
    });

    testWidgets('VerifyScreen back button pops to previous screen',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          authFlowProvider.overrideWith(_FakeResetFlowNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: RoutePath.findPassword,
        routes: [
          GoRoute(
            path: RoutePath.findPassword,
            builder: (context, state) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('find-password-screen'),
                    ElevatedButton(
                      onPressed: () => context.push(RoutePath.verify),
                      child: const Text('open-verify'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GoRoute(
            path: RoutePath.verify,
            builder: (context, state) =>
                const VerifyScreen(redirectPath: RoutePath.resetPassword),
          ),
          GoRoute(
            path: RoutePath.password,
            builder: (context, state) =>
                const Scaffold(body: Text('password-screen')),
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
      await tester.tap(find.text('open-verify'));
      await tester.pumpAndSettle();

      await tester.tap(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(TextButton),
            )
            .first,
      );
      await tester.pumpAndSettle();

      expect(find.text('find-password-screen'), findsOneWidget);
    });
  });
}

class _FakePasswordResetRepository implements PasswordResetRemoteDataSource {
  String? sentEmail;
  EmailVerificationPurpose? sentPurpose;
  String? changedEmail;
  String? changedVerifiedToken;
  String? changedPassword;

  @override
  Future<void> changePassword(ChangePasswordRequestDto requestDto) async {
    changedEmail = requestDto.email;
    changedVerifiedToken = requestDto.verifiedToken;
    changedPassword = requestDto.newPassword;
  }

  @override
  Future<void> sendEmailVerification(
    SendEmailVerificationRequestDto requestDto,
  ) async {
    sentEmail = requestDto.email;
    sentPurpose = requestDto.purpose;
  }
}

class _FakeThemeModeNotifier extends ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async => AppThemeOption.system.themeMode;
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
        name: '홍길동',
        grade: 2,
        department: 'SW',
        lateCount: 3,
      );
}

class _FakeCurrentMemberNotifier extends CurrentMemberNotifier {
  @override
  Future<CurrentMemberEntity?> build() async => const CurrentMemberEntity(
        memberId: 1,
        email: 's24068@gsm.hs.kr',
        name: '홍길동',
        role: RoleEnum.user,
      );
}

class _FakeResetFlowNotifier extends AuthFlowNotifier {
  @override
  AuthFlowState build() => const AuthFlowState(
        email: 's24068@gsm.hs.kr',
        purpose: EmailVerificationPurpose.passwordChange,
      );
}

class _FakeVerifiedResetFlowNotifier extends AuthFlowNotifier {
  @override
  AuthFlowState build() => const AuthFlowState(
        email: 's24068@gsm.hs.kr',
        purpose: EmailVerificationPurpose.passwordChange,
        verifiedToken: 'verified-token',
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

class _FakeEmailVerificationRepository
    implements EmailVerificationRemoteDataSource {
  _FakeEmailVerificationRepository({this.confirmException});

  final DioException? confirmException;

  @override
  Future<ConfirmEmailVerificationResponseDto> confirmEmailVerification(
    ConfirmEmailVerificationRequestDto requestDto,
  ) async {
    if (confirmException != null) {
      throw confirmException!;
    }
    return const ConfirmEmailVerificationResponseDto(
      verifiedToken: 'verified-token',
    );
  }

  @override
  Future<void> sendEmailVerification(
    SendEmailVerificationRequestDto requestDto,
  ) async {}
}
