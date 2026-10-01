import 'package:go_router/go_router.dart';
import 'package:goms/features/member/presentation/routes/member_route_path.dart';
import 'package:goms/features/member/presentation/screens/member_list_screen.dart';

List<RouteBase> buildMemberRoutes() => [
      GoRoute(
        path: MemberRoutePath.members,
        name: 'members',
        builder: (context, state) => const MemberListScreen(),
      ),
    ];
