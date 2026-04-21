import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/ui/shell/main_shell.dart';
import 'package:goms/features/auth/ui/routes/auth_routes.dart';
import 'package:goms/features/map/ui/routes/map_routes.dart';
import 'package:goms/features/member/ui/routes/member_routes.dart';
import 'package:goms/features/outing/ui/routes/outing_routes.dart';
import 'package:goms/features/profile/ui/routes/profile_routes.dart';
import 'package:goms/features/qr/ui/routes/qr_routes.dart';
import 'package:goms/features/report/ui/routes/report_routes.dart';
import 'package:goms/features/splash/ui/routes/splash_routes.dart';
import 'route_path.dart';

export 'route_builders.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePath.splash,
  routes: [
    ...buildSplashRoutes(),
    ...buildAuthRoutes(),
    ...buildQrRoutes(),
    ...buildOutingRoutes(),
    ...buildReportRoutes(),
    ...buildProfileRoutes(),
    ...buildMemberRoutes(),
    ...buildMapRoutes(),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        buildMapShellBranch(),
        buildHomeShellBranch(),
        buildProfileShellBranch(),
      ],
    ),
  ],
);
