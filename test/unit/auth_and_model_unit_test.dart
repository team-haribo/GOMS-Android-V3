import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/auth/login/presentation/models/login_state.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_provider.dart';
import 'package:goms/features/home/shared/presentation/widgets/search_profile_container_model.dart';

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
        name: '이주언',
        grade: 3,
        major: 'AI',
        studentRole: StudentRole.student,
      );

      expect(model.name, '이주언');
      expect(model.grade, 3);
      expect(model.major, 'AI');
    });
  });

  test('RoleEnum values are defined in expected order', () {
    expect(RoleEnum.values, [RoleEnum.admin, RoleEnum.user]);
  });

  group('auth flow helpers', () {
    test('normalizeSchoolEmail appends domain when only local part is given',
        () {
      expect(normalizeSchoolEmail('s24068'), 's24068@gsm.hs.kr');
      expect(normalizeSchoolEmail('s24068@gsm.hs.kr'), 's24068@gsm.hs.kr');
    });

    test('isAllowedSchoolEmail only accepts gsm domain', () {
      expect(isAllowedSchoolEmail('s24068'), isTrue);
      expect(isAllowedSchoolEmail('s24068@gsm.hs.kr'), isTrue);
      expect(isAllowedSchoolEmail('s24068@gmail.com'), isFalse);
      expect(isAllowedSchoolEmail('wrong@@gsm.hs.kr'), isFalse);
    });

    test('inferGradeFromEmail extracts first digit after s', () {
      expect(inferGradeFromEmail('s24068'), 2);
      expect(inferGradeFromEmail('s3101@gsm.hs.kr'), 3);
    });
  });
}
