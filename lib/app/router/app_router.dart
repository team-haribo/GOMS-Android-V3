import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/presentation/shell/main_shell.dart';
import 'package:goms/features/auth/shared/presentation/routes/auth_routes.dart';
import 'package:goms/features/map/routes/map_routes.dart';
import 'package:goms/features/member/presentation/routes/member_routes.dart';
import 'package:goms/features/outing/presentation/routes/outing_routes.dart';
import 'package:goms/features/profile/presentation/routes/profile_routes.dart';
import 'package:goms/features/qr/presentation/routes/qr_routes.dart';
import 'package:goms/features/report/presentation/routes/report_routes.dart';
import 'package:goms/features/splash/presentation/routes/splash_routes.dart';
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
