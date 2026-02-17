import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_path.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePath.home,
  routes: [
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
