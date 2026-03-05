import 'package:flutter_test/flutter_test.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/presentation/auth/signup/models/signup_state.dart';

void main() {
  group('RoutePath', () {
    test('all route constants start with slash', () {
      const routes = [
        RoutePath.splash,
        RoutePath.onboarding,
        RoutePath.login,
        RoutePath.signUp,
        RoutePath.password,
        RoutePath.verify,
        RoutePath.findPassword,
        RoutePath.resetPassword,
        RoutePath.qr,
        RoutePath.deleteAccount,
        RoutePath.map,
        RoutePath.home,
        RoutePath.myPage,
      ];

      for (final route in routes) {
        expect(route.startsWith('/'), isTrue, reason: 'route: $route');
      }
    });

    test('route constants are unique', () {
      const routes = [
        RoutePath.splash,
        RoutePath.onboarding,
        RoutePath.login,
        RoutePath.signUp,
        RoutePath.password,
        RoutePath.verify,
        RoutePath.findPassword,
        RoutePath.resetPassword,
        RoutePath.qr,
        RoutePath.deleteAccount,
        RoutePath.map,
        RoutePath.home,
        RoutePath.myPage,
      ];

      expect(routes.toSet().length, routes.length);
    });
  });

  group('SignupState', () {
    test('initial factory returns expected default values', () {
      final state = SignupState.initial();

      expect(state.status, SignupStatus.initial);
      expect(state.name, '');
      expect(state.email, '');
      expect(state.password, '');
      expect(state.passwordConfirm, '');
      expect(state.gender, isNull);
      expect(state.major, isNull);
      expect(state.nameError, isNull);
      expect(state.emailError, isNull);
      expect(state.passwordError, isNull);
      expect(state.passwordConfirmError, isNull);
      expect(state.errorMessage, isNull);
    });
  });
}
