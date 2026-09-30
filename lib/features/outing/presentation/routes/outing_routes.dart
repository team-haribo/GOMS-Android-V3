import 'package:go_router/go_router.dart';
import 'package:goms/features/member/presentation/widgets/admin_route_guard_widget.dart';
import 'package:goms/features/outing/presentation/routes/outing_route_path.dart';
import 'package:goms/features/outing/presentation/screens/admin_latecomer_list_screen.dart';
import 'package:goms/features/outing/presentation/screens/admin_outing_state_screen.dart';
import 'package:goms/features/outing/presentation/screens/outing_state_screen.dart';
import 'package:goms/features/outing/presentation/screens/outing_waiting_screen.dart';

List<RouteBase> buildOutingRoutes() => [
      GoRoute(
        path: OutingRoutePath.outingState,
        name: 'outingState',
        builder: (context, state) => const OutingStateScreen(),
      ),
      GoRoute(
        path: OutingRoutePath.studentCouncilMembers,
        name: 'studentCouncilMembers',
        builder: (context, state) => const AdminRouteGuard(
          child: AdminOutingStateScreen(),
        ),
      ),
      GoRoute(
        path: OutingRoutePath.studentCouncilLate,
        name: 'studentCouncilLate',
        builder: (context, state) => const AdminRouteGuard(
          child: AdminLatecomerListScreen(),
        ),
      ),
    ];

StatefulShellBranch buildHomeShellBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: OutingRoutePath.home,
        name: 'home',
        builder: (context, state) => const OutingWaitingScreen(),
      ),
    ],
  );
}
