import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/features/auth/presentation/pages/signup/models/signup_state.dart';

void main() {
  group('RoutePath', () {
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

    test('all route constants start with slash', () {
      for (final route in routes) {
        expect(route.startsWith('/'), isTrue, reason: 'route: $route');
      }
    });

    test('route constants are unique', () {
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

