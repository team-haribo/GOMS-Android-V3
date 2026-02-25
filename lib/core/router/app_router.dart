import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/presentation/auth/login/screens/login_screen.dart';
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
      path: RoutePath.qr,
      name: 'qr',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: RoutePath.home,
      name: 'home',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: RoutePath.myPage,
      name: 'myPage',
      builder: (context, state) => const Placeholder(),
    ),
  ],
);
