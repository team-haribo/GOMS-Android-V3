import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/profile/presentation/screens/my_page_screen.dart';
import 'package:goms/features/profile/presentation/screens/privacy_policy_screen.dart';

List<RouteBase> buildProfileRoutes() => [
      GoRoute(
        path: RoutePath.privacyPolicy,
        name: 'privacyPolicy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ];

StatefulShellBranch buildProfileShellBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: RoutePath.myPage,
        name: 'myPage',
        builder: (context, state) => const MyPageScreen(),
      ),
    ],
  );
}
