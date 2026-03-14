import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/auth/presentation/pages/login/models/login_state.dart';
import 'package:goms/features/main_page/presentation/widgets/search_profile_container_model.dart';

void main() {
  group('LoginState', () {
    test('initial factory returns default state', () {
      final state = LoginState.initial();

      expect(state.status, LoginStatus.initial);
      expect(state.errorMessage, isNull);
      expect(state.email, isNull);
      expect(state.emailError, isNull);
      expect(state.passwordError, isNull);
    });

    test('loading/success/failure factories set expected fields', () {
      final loading = LoginState.loading();
      final success = LoginState.success('student@gsm.hs.kr');
      final failure = LoginState.failure('login failed');

      expect(loading.status, LoginStatus.loading);
      expect(success.status, LoginStatus.success);
      expect(success.email, 'student@gsm.hs.kr');
      expect(failure.status, LoginStatus.failure);
      expect(failure.errorMessage, 'login failed');
    });
  });

  group('SearchProfileContainerModel', () {
    test('stores constructor values', () {
      const model = SearchProfileContainerModel(
        name: 'Hong',
        grade: 2,
        major: 'SW',
      );

      expect(model.name, 'Hong');
      expect(model.grade, 2);
      expect(model.major, 'SW');
    });
  });

  test('RoleEnum values are defined in expected order', () {
    expect(RoleEnum.values, [RoleEnum.admin, RoleEnum.user]);
  });
}
