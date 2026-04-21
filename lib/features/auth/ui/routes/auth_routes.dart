import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/auth/delete_account/ui/screens/delete_account_screen.dart';
import 'package:goms/features/auth/login/ui/screens/login_screen.dart';
import 'package:goms/features/auth/password_reset/ui/screens/find_password_screen.dart';
import 'package:goms/features/auth/password_reset/ui/screens/reset_password_screen.dart';
import 'package:goms/features/auth/signup/ui/screens/password_screen.dart';
import 'package:goms/features/auth/signup/ui/screens/signup_screen.dart';
import 'package:goms/features/auth/verification/ui/screens/verify_screen.dart';

List<RouteBase> buildAuthRoutes() => [
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
        path: RoutePath.deleteAccount,
        name: 'deleteAccount',
        builder: (context, state) => const DeleteAccountScreen(),
      ),
    ];
