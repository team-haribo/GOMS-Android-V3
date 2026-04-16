import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/member/ui/screens/member_list_screen.dart';

List<RouteBase> buildMemberRoutes() => [
      GoRoute(
        path: RoutePath.members,
        name: 'members',
        builder: (context, state) => const MemberListScreen(),
      ),
    ];
