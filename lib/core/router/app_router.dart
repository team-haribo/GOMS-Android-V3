import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/features/auth/delete_account/presentation/screens/delete_account_screen.dart';
import 'package:goms/features/auth/login/presentation/screens/login_screen.dart';
import 'package:goms/features/auth/password_reset/presentation/screens/find_password_screen.dart';
import 'package:goms/features/auth/password_reset/presentation/screens/reset_password_screen.dart';
import 'package:goms/features/auth/signup/presentation/screens/password_screen.dart';
import 'package:goms/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:goms/features/auth/verification/presentation/screens/verify_screen.dart';
import 'package:goms/features/home/shared/presentation/widgets/main_shell.dart';
import 'package:goms/features/map/direction/presentation/screens/direction_screen.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/discovery/presentation/screens/map_screen.dart';
import 'package:goms/features/map/review/presentation/screens/write_review_screen.dart';
import 'package:goms/features/map/shared/presentation/models/map_screen_type.dart';
import 'package:goms/features/map/shared/presentation/screens/map_base_screen.dart';
import 'package:goms/features/member/presentation/screens/member_list_screen.dart';
import 'package:goms/features/outing/presentation/screens/admin_latecomer_list_screen.dart';
import 'package:goms/features/outing/presentation/screens/admin_outing_state_screen.dart';
import 'package:goms/features/outing/presentation/screens/outing_state_screen.dart';
import 'package:goms/features/outing/presentation/screens/outing_waiting_screen.dart';
import 'package:goms/features/profile/presentation/screens/my_page_screen.dart';
import 'package:goms/features/profile/presentation/screens/privacy_policy_screen.dart';
import 'package:goms/features/qr/presentation/screens/qr_issue_screen.dart';
import 'package:goms/features/qr/presentation/screens/qr_scan_screen.dart';
import 'package:goms/features/report/presentation/screens/admin_report_detail_screen.dart';
import 'package:goms/features/report/presentation/screens/admin_report_list_screen.dart';
import 'package:goms/features/splash/presentation/screens/onboarding_screen.dart';
import 'package:goms/features/splash/presentation/screens/splash_screen.dart';
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
      builder: (context, state) => const QrScanScreen(),
    ),
    GoRoute(
      path: RoutePath.qrIssue,
      name: 'qrIssue',
      builder: (context, state) => const QrIssueScreen(),
    ),
    GoRoute(
      path: RoutePath.outingState,
      name: 'outingState',
      builder: (context, state) => const OutingStateScreen(),
    ),
    GoRoute(
      path: RoutePath.studentCouncilMembers,
      name: 'studentCouncilMembers',
      builder: (context, state) => const AdminOutingStateScreen(),
    ),
    GoRoute(
      path: RoutePath.studentCouncilLate,
      name: 'studentCouncilLate',
      builder: (context, state) => const AdminLatecomerListScreen(),
    ),
    GoRoute(
      path: RoutePath.studentCouncilReports,
      name: 'studentCouncilReports',
      builder: (context, state) => const AdminReportListScreen(),
    ),
    GoRoute(
      path: RoutePath.studentCouncilReportDetail,
      name: 'studentCouncilReportDetail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! int) {
          return const Scaffold(
            body: Center(child: Text('잘못된 접근입니다.')),
          );
        }
        return AdminReportDetailScreen(reportId: extra);
      },
    ),
    GoRoute(
      path: RoutePath.deleteAccount,
      name: 'deleteAccount',
      builder: (context, state) => const DeleteAccountScreen(),
    ),
    GoRoute(
      path: RoutePath.privacyPolicy,
      name: 'privacyPolicy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: RoutePath.members,
      name: 'members',
      builder: (context, state) => const MemberListScreen(),
    ),
    GoRoute(
      path: RoutePath.writeReview,
      name: 'writeReview',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! PopularPlace) {
          return const Scaffold(
            body: Center(child: Text('잘못된 접근입니다.')),
          );
        }

        return WriteReviewScreen(
          placeId: extra.placeId,
          placeName: extra.name,
          category: extra.category,
          address: extra.address,
          review: extra.review,
          recommended: extra.recommended,
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.map,
              name: 'map',
              builder: (context, state) => const MapScreen(),
              routes: [
                GoRoute(
                  path: 'direction',
                  name: 'direction',
                  builder: (context, state) {
                    final extra = state.extra;
                    if (extra is! PopularPlace) {
                      return const Scaffold(
                        body: Center(child: Text('잘못된 접근입니다.')),
                      );
                    }
                    return DirectionScreen(place: extra);
                  },
                ),
              ],
            ),
            GoRoute(
              path: RoutePath.mapDetail,
              name: 'mapDetail',
              builder: (context, state) {
                final extra = state.extra;
                if (extra is! PopularPlace) {
                  return const Scaffold(
                    body: Center(child: Text('잘못된 접근입니다.')),
                  );
                }
                return MapBaseScreen(
                  type: MapScreenType.detail,
                  place: extra,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.home,
              name: 'home',
              builder: (context, state) => const OutingWaitingScreen(),
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
