import 'package:go_router/go_router.dart';
import 'package:goms/features/splash/presentation/routes/splash_route_path.dart';
import 'package:goms/features/splash/presentation/screens/onboarding_screen.dart';
import 'package:goms/features/splash/presentation/screens/splash_screen.dart';

List<RouteBase> buildSplashRoutes() => [
      GoRoute(
        path: SplashRoutePath.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: SplashRoutePath.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ];
