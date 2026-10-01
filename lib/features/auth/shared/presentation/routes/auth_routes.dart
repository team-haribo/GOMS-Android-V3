import 'package:go_router/go_router.dart';
import 'package:goms/features/auth/shared/presentation/routes/auth_route_path.dart';
import 'package:goms/features/auth/delete_account/presentation/screens/delete_account_screen.dart';
import 'package:goms/features/auth/login/presentation/screens/login_screen.dart';
import 'package:goms/features/auth/password_reset/presentation/screens/find_password_screen.dart';
import 'package:goms/features/auth/password_reset/presentation/screens/reset_password_screen.dart';
import 'package:goms/features/auth/signup/presentation/screens/password_screen.dart';
import 'package:goms/features/auth/signup/presentation/screens/signup_screen.dart';
import 'package:goms/features/auth/shared/presentation/routes/verify_route_extra.dart';
import 'package:goms/features/auth/verification/presentation/screens/verify_screen.dart';

List<RouteBase> buildAuthRoutes() => [
      GoRoute(
        path: AuthRoutePath.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AuthRoutePath.signUp,
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AuthRoutePath.password,
        name: 'password',
        builder: (context, state) => const PasswordScreen(),
      ),
      GoRoute(
        path: AuthRoutePath.verify,
        name: 'verify',
        builder: (context, state) {
          final extra = state.extra;
          final routeExtra = switch (extra) {
            VerifyRouteExtra() => extra,
            String() => VerifyRouteExtra(redirectPath: extra),
            _ => const VerifyRouteExtra(),
          };

          return VerifyScreen(
            redirectPath: routeExtra.redirectPath,
            backPath: routeExtra.backPath,
          );
        },
      ),
      GoRoute(
        path: AuthRoutePath.findPassword,
        name: 'findPassword',
        builder: (context, state) => const FindPasswordScreen(),
      ),
      GoRoute(
        path: AuthRoutePath.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AuthRoutePath.deleteAccount,
        name: 'deleteAccount',
        builder: (context, state) => const DeleteAccountScreen(),
      ),
    ];
