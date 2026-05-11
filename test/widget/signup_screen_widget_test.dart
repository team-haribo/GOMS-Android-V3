import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/auth/signup/presentation/viewmodels/signup_viewmodel.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:goms/features/auth/signup/presentation/models/signup_state.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/profile/presentation/screens/privacy_policy_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('SignupScreen shows privacy policy row and consent button flow',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: RoutePath.signUp,
      routes: [
        GoRoute(
          path: RoutePath.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: RoutePath.privacyPolicy,
          builder: (context, state) => const PrivacyPolicyScreen(),
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

    expect(find.text('개인정보 수집 및 처리방침'), findsOneWidget);
    expect(container.read(signupProvider).isPrivacyPolicyAgreed, isFalse);

    await tester.ensureVisible(find.text('개인정보 수집 및 처리방침'));
    await tester.tap(find.text('개인정보 수집 및 처리방침'));
    await tester.pumpAndSettle();

    expect(find.text('개인정보 수집 및 처리방침'), findsOneWidget);
    expect(find.text('1. 개인정보 수집 항목 및 방법'), findsOneWidget);
    expect(find.text('개인정보 수집 동의'), findsOneWidget);

    await tester.tap(find.text('개인정보 수집 동의'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('기수를 선택해주세요'), findsOneWidget);
    expect(container.read(signupProvider).isPrivacyPolicyAgreed, isTrue);
  });

  testWidgets('SignupScreen back navigation clears signup state',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => context.push(RoutePath.signUp),
                  child: const Text('open signup'),
                ),
              ),
            ),
          ),
        ),
        GoRoute(
          path: RoutePath.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: RoutePath.privacyPolicy,
          builder: (context, state) => const PrivacyPolicyScreen(),
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
    await tester.tap(find.text('open signup'));
    await tester.pumpAndSettle();

    final notifier = container.read(signupProvider.notifier);
    notifier.setName('Hong');
    notifier.validateEmail('s1001');
    notifier.validateGrade('8');
    notifier.setGender(GenderType.male);
    notifier.setMajor(DepartmentType.sw);
    notifier.setPrivacyPolicyAgreed(true);

    await tester.pump();
    final backButton = find.widgetWithText(TextButton, '돌아가기');
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text('open signup'), findsOneWidget);
    expect(container.read(signupProvider), SignupState.initial());
  });

  testWidgets('SignupScreen shows grade dropdown options', (tester) async {
    final router = GoRouter(
      initialLocation: RoutePath.signUp,
      routes: [
        GoRoute(
          path: RoutePath.signUp,
          builder: (context, state) => const SignUpScreen(),
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

    await tester.pumpAndSettle();

    await tester.tap(find.text('기수를 선택해주세요'));
    await tester.pumpAndSettle();

    expect(find.text('8기'), findsOneWidget);
    expect(find.text('9기'), findsOneWidget);
    expect(find.text('10기'), findsOneWidget);
    expect(find.text('7기'), findsNothing);
    expect(find.text('11기'), findsNothing);
  });
}
