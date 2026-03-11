import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/presentation/auth/login/screens/login_screen.dart';
import 'package:goms/presentation/auth/reset_password/screens/find_password_screen.dart';
import 'package:goms/presentation/auth/reset_password/screens/reset_password_screen.dart';
import 'package:goms/presentation/auth/signup/screens/signup_screen.dart';
import 'package:goms/presentation/auth/signup/screens/password_screen.dart';
import 'package:goms/presentation/auth/verify/screens/verify_screen.dart';
import 'package:goms/presentation/main_page/screens/outing_state_screen.dart';
import 'package:goms/presentation/main_page/screens/outing_waiting_screen.dart';
import 'package:goms/presentation/main_page/widget/main_shell.dart';
import 'package:goms/presentation/map/base/models/map_screen_type.dart';
import 'package:goms/presentation/map/base/screens/map_base_screen.dart';
import 'package:goms/presentation/map/direction/screens/direction_screen.dart';
import 'package:goms/presentation/map/main/screens/map_page.dart';
import 'package:goms/presentation/map/review/screens/write_review_screen.dart';
import 'package:goms/presentation/map/widget/map_page_models.dart';
import 'package:goms/presentation/my_page/screens/my_page_screen.dart';
import 'package:goms/presentation/auth/delete_account/screens/delete_account_screen.dart';
import 'package:goms/presentation/qr/scan/screens/qr_scan_screen.dart';
import 'package:goms/presentation/splash/onboarding_screen.dart';
import 'package:goms/presentation/splash/splash_screen.dart';
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
      builder: (context, state) => const OutingStateScreen(),
    ),
    GoRoute(
      path: RoutePath.deleteAccount,
      name: 'deleteAccount',
      builder: (context, state) => const DeleteAccountScreen(),
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
                    final place = state.extra as PopularPlace;
                    return DirectionScreen(place: place);
                  },
                ),
              ],
            ),
            GoRoute(
              path: RoutePath.mapDetail,
              name: 'mapDetail',
              builder: (context, state) {
                final place = state.extra as PopularPlace;
                return MapBaseScreen(
                  type: MapScreenType.detail,
                  place: place,
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
              builder: (context, state) => const OutingWaitingScreen(
                approvedStudentCount: 0,
                hasLateStudents: false,
              ),
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
