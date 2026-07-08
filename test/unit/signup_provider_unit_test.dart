import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_viewmodel.dart';
import 'package:goms/features/auth/signup/data/datasources/signup_remote_datasource.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/signup/data/request/signup/signup_request_dto.dart';
import 'package:goms/features/auth/signup/data/providers/signup_data_providers.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/features/auth/signup/presentation/models/signup_state.dart';
import 'package:goms/features/auth/signup/presentation/viewmodels/signup_viewmodel.dart';

void main() {
  group('SignupNotifier validation', () {
    test('email validation updates error state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);

      notifier.validateEmail('wrong-email');
      expect(container.read(signupProvider).emailError, isNotNull);

      notifier.validateEmail('s1234');
      expect(container.read(signupProvider).emailError, isNull);
      expect(container.read(signupProvider).email, 's1234');
    });

    test('isFormValid becomes true when required fields are set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('8');
      notifier.setGender(GenderType.male);
      notifier.setMajor(DepartmentType.sw);
      notifier.setPrivacyPolicyAgreed(true);

      expect(notifier.isFormValid, isTrue);
      expect(container.read(signupProvider).status, SignupStatus.initial);
    });

    test('grade validation only accepts the supported cohorts', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);

      expect(SignupNotifier.availableGrades, const <int>[8, 9, 10]);

      notifier.validateGrade('9');
      expect(container.read(signupProvider).gradeError, isNull);

      notifier.validateGrade('7');
      expect(
        container.read(signupProvider).gradeError,
        '기수는 8기, 9기, 10기만 선택할 수 있습니다',
      );
    });

    test('password confirmation mismatch is detected and recovered', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);

      notifier.validatePassword('Abc123!');
      notifier.validatePasswordConfirm('Abc123@');
      expect(container.read(signupProvider).passwordConfirmError, isNotNull);

      notifier.validatePasswordConfirm('Abc123!');
      expect(container.read(signupProvider).passwordConfirmError, isNull);
      expect(notifier.isPasswordFormValid, isTrue);
    });

    test('resetStatus clears terminal state without removing form input', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.state = container.read(signupProvider).copyWith(
            status: SignupStatus.success,
            errorMessage: 'temporary',
          );

      notifier.resetStatus();

      expect(container.read(signupProvider).status, SignupStatus.initial);
      expect(container.read(signupProvider).errorMessage, isNull);
      expect(container.read(signupProvider).name, 'Hong');
      expect(container.read(signupProvider).email, 's1001');
    });

    test('signup request maps gender to API enum format', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);
      final authFlow = container.read(authFlowProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('8');
      notifier.setGender(GenderType.male);
      notifier.setMajor(DepartmentType.sw);
      notifier.setPrivacyPolicyAgreed(true);
      notifier.validatePassword('Abc123!');
      notifier.validatePasswordConfirm('Abc123!');
      authFlow.startSignup('s1001@gsm.hs.kr');
      authFlow.setVerifiedToken('verified-token');

      notifier.state = container.read(signupProvider).copyWith(
            status: SignupStatus.loading,
          );

      expect(
        {
          'email': container.read(authFlowProvider).email,
          'verifiedToken': container.read(authFlowProvider).verifiedToken,
          'password': container.read(signupProvider).password,
          'name': container.read(signupProvider).name,
          'grade': int.parse(container.read(signupProvider).grade),
          'department':
              container.read(signupProvider).major!.name.toUpperCase(),
          'gender': switch (container.read(signupProvider).gender!) {
            GenderType.male => 'MALE',
            GenderType.female => 'FEMALE',
          },
        }['gender'],
        'MALE',
      );
    });

    test('submitSignup skips resend when email matches existing signup flow',
        () async {
      final remote = _FakeAuthRemoteDataSource();
      final container = ProviderContainer(
        overrides: [
          signupRemoteDataSourceProvider.overrideWithValue(remote),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);
      final authFlow = container.read(authFlowProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('8');
      notifier.setGender(GenderType.male);
      notifier.setMajor(DepartmentType.sw);
      notifier.setPrivacyPolicyAgreed(true);
      authFlow.startSignup('s1001@gsm.hs.kr');

      await notifier.submitSignup();

      expect(remote.sendEmailVerificationCallCount, 0);
      expect(container.read(signupProvider).status, SignupStatus.success);
      expect(container.read(authFlowProvider).email, 's1001@gsm.hs.kr');
    });

    test(
        'submitSignup preserves verified token when email matches existing signup flow',
        () async {
      final remote = _FakeAuthRemoteDataSource();
      final container = ProviderContainer(
        overrides: [
          signupRemoteDataSourceProvider.overrideWithValue(remote),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);
      final authFlow = container.read(authFlowProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('8');
      notifier.setGender(GenderType.male);
      notifier.setMajor(DepartmentType.sw);
      notifier.setPrivacyPolicyAgreed(true);
      authFlow.startSignup('s1001@gsm.hs.kr');
      authFlow.setVerifiedToken('verified-token');

      await notifier.submitSignup();

      expect(remote.sendEmailVerificationCallCount, 0);
      expect(
        container.read(authFlowProvider).verifiedToken,
        'verified-token',
      );
    });

    test('submitSignup maps 409 to email field error', () async {
      final remote = _FakeAuthRemoteDataSource(
        sendEmailVerificationException: DioException(
          requestOptions: RequestOptions(
            path: '/api/v3/auth/email-verifications/send',
          ),
          response: Response<void>(
            requestOptions: RequestOptions(
              path: '/api/v3/auth/email-verifications/send',
            ),
            statusCode: 409,
          ),
        ),
      );
      final container = ProviderContainer(
        overrides: [
          signupRemoteDataSourceProvider.overrideWithValue(remote),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('8');
      notifier.setGender(GenderType.male);
      notifier.setMajor(DepartmentType.sw);
      notifier.setPrivacyPolicyAgreed(true);

      await notifier.submitSignup();

      expect(container.read(signupProvider).status, SignupStatus.failure);
      expect(container.read(signupProvider).emailError, '이미 가입된 이메일입니다.');
      expect(container.read(signupProvider).errorMessage, isNull);
    });
  });
}

class _FakeAuthRemoteDataSource implements SignupRemoteDataSource {
  _FakeAuthRemoteDataSource({this.sendEmailVerificationException});

  int sendEmailVerificationCallCount = 0;
  final DioException? sendEmailVerificationException;

  @override
  Future<void> sendEmailVerification(
    SendEmailVerificationRequestDto requestDto,
  ) async {
    if (sendEmailVerificationException != null) {
      throw sendEmailVerificationException!;
    }
    sendEmailVerificationCallCount++;
  }

  @override
  Future<void> signUp(SignUpRequestDto requestDto) {
    throw UnimplementedError();
  }
}
