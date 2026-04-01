import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/features/auth/delete_account/presentation/screens/delete_account_screen.dart';
import 'package:goms/features/auth/login/presentation/screens/login_screen.dart';
import 'package:goms/features/auth/password_reset/presentation/screens/find_password_screen.dart';
import 'package:goms/features/auth/password_reset/presentation/screens/reset_password_screen.dart';
import 'package:goms/features/auth/signup/presentation/screens/password_screen.dart';
import 'package:goms/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:goms/features/auth/verification/presentation/screens/verify_screen.dart';
import 'package:goms/features/home/outing_status/presentation/screens/outing_state_screen.dart';
import 'package:goms/features/home/outing_waiting/presentation/screens/outing_waiting_screen.dart';
import 'package:goms/features/home/shared/presentation/widgets/main_shell.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/shared/presentation/screens/map_base_screen.dart';
import 'package:goms/features/map/shared/presentation/models/map_screen_type.dart';
import 'package:goms/features/map/direction/presentation/screens/direction_screen.dart';
import 'package:goms/features/map/discovery/presentation/screens/map_page.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/review/presentation/screens/write_review_screen.dart';
import 'package:goms/features/member/presentation/screens/member_list_screen.dart';
import 'package:goms/features/profile/overview/presentation/screens/my_page_screen.dart';
import 'package:goms/features/qr/scan/presentation/screens/qr_scan_screen.dart';
import 'package:goms/features/splash/presentation/pages/onboarding_screen.dart';
import 'package:goms/features/splash/presentation/pages/splash_screen.dart';
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
      path: RoutePath.outingState,
      name: 'outingState',
      builder: (context, state) {
        return const OutingStateScreen();
      },
    ),
    GoRoute(
      path: RoutePath.deleteAccount,
      name: 'deleteAccount',
      builder: (context, state) => const DeleteAccountScreen(),
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
        final place = state.extra is PopularPlace
            ? state.extra as PopularPlace
            : const PopularPlace(
                name: '테스트 가게',
                category: '카페',
                address: '광주광역시 광산구 송정동',
                review: 5,
                recommended: 10,
                coordinate: MapCoordinate(
                  latitude: 35.139783,
                  longitude: 126.793442,
                ),
              );
        return WriteReviewScreen(
          placeName: place.name,
          category: place.category,
          address: place.address,
          review: place.review,
          recommended: place.recommended,
        );
      },
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
              builder: (context, state) => const MapPage(),
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
              builder: (context, state) {
                return const OutingWaitingScreen(
                  approvedStudentCount: 3,
                  hasLateStudents: false,
                );
              },
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
