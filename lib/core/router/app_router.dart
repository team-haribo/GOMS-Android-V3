import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/presentation/auth/login/screens/login_screen.dart';
import 'package:project_setting/presentation/auth/reset_password/screens/find_password_screen.dart';
import 'package:project_setting/presentation/auth/reset_password/screens/reset_password_screen.dart';
import 'package:project_setting/presentation/auth/signup/screens/signup_screen.dart';
import 'package:project_setting/presentation/auth/signup/screens/password_screen.dart';
import 'package:project_setting/presentation/auth/verify/screens/verify_screen.dart';
import 'package:project_setting/presentation/main_page/widget/main_shell.dart';
import 'package:project_setting/presentation/my_page/screens/my_page_screen.dart';
import 'package:project_setting/presentation/splash/onboarding_screen.dart';
import 'package:project_setting/presentation/splash/splash_screen.dart';
import 'route_path.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePath.splash,
  routes: [
    GoRoute(
      path: RoutePath.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePath.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RoutePath.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePath.signUp,
      name: 'signUp',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: RoutePath.password,
      name: 'password',
      builder: (context, state) => const PasswordScreen(),
    ),
    GoRoute(
      path: RoutePath.verify,
      name: 'verify',
      builder: (context, state) => VerifyScreen(
        redirectPath: state.extra as String?,
      ),
    ),
    GoRoute(
      path: RoutePath.findPassword,
      name: 'findPassword',
      builder: (context, state) => const FindPasswordScreen(),
    ),
    GoRoute(
      path: RoutePath.resetPassword,
      name: 'resetPassword',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: RoutePath.qr,
      name: 'qr',
      builder: (context, state) => const Placeholder(),
    ),
    // ==================== 바텀 네비게이션 쉘 ====================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.map,
              name: 'map',
              builder: (context, state) => const Placeholder(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.home,
              name: 'home',
              builder: (context, state) => const Placeholder(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.myPage,
              name: 'myPage',
              builder: (context, state) => const MyPageScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
