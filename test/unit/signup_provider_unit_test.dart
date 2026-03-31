import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/gender_enum.dart';
import 'package:goms/core/enums/major_enum.dart';
import 'package:goms/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:goms/features/auth/data/dto/email_verification/confirm_email_verification_request_dto.dart';
import 'package:goms/features/auth/data/dto/email_verification/confirm_email_verification_response_dto.dart';
import 'package:goms/features/auth/data/dto/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/data/dto/password/change_password_request_dto.dart';
import 'package:goms/features/auth/data/dto/signin/signin_request_dto.dart';
import 'package:goms/features/auth/data/dto/signin/signin_response_dto.dart';
import 'package:goms/features/auth/data/dto/signup/signup_request_dto.dart';
import 'package:goms/features/auth/data/providers/auth_data_providers.dart';
import 'package:goms/features/auth/data/repositories/auth_repository.dart';
import 'package:goms/features/auth/presentation/viewmodels/auth_flow_provider.dart';
import 'package:goms/features/auth/presentation/pages/signup/models/signup_state.dart';
import 'package:goms/features/auth/presentation/pages/signup/viewModels/signup_provider.dart';

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
      notifier.validateGrade('3');
      notifier.setGender(GenderEnum.man);
      notifier.setMajor(MajorEnum.sw);

      expect(notifier.isFormValid, isTrue);
      expect(container.read(signupProvider).status, SignupStatus.initial);
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
      notifier.validateGrade('3');
      notifier.setGender(GenderEnum.man);
      notifier.setMajor(MajorEnum.sw);
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
          'department': container.read(signupProvider).major!.name.toUpperCase(),
          'gender': switch (container.read(signupProvider).gender!) {
            GenderEnum.man => 'MALE',
            GenderEnum.woman => 'FEMALE',
          },
        }['gender'],
        'MALE',
      );
    });

    test('submitSignup skips resend when email matches existing signup flow', () async {
      final remote = _FakeAuthRemoteDataSource();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepository(remoteDataSource: remote),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);
      final authFlow = container.read(authFlowProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('3');
      notifier.setGender(GenderEnum.man);
      notifier.setMajor(MajorEnum.sw);
      authFlow.startSignup('s1001@gsm.hs.kr');

      await notifier.submitSignup();

      expect(remote.sendEmailVerificationCallCount, 0);
      expect(container.read(signupProvider).status, SignupStatus.success);
      expect(container.read(authFlowProvider).email, 's1001@gsm.hs.kr');
    });

    test('submitSignup preserves verified token when email matches existing signup flow', () async {
      final remote = _FakeAuthRemoteDataSource();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepository(remoteDataSource: remote),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);
      final authFlow = container.read(authFlowProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('3');
      notifier.setGender(GenderEnum.man);
      notifier.setMajor(MajorEnum.sw);
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
          authRepositoryProvider.overrideWithValue(
            AuthRepository(remoteDataSource: remote),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(signupProvider.notifier);

      notifier.setName('Hong');
      notifier.validateEmail('s1001');
      notifier.validateGrade('3');
      notifier.setGender(GenderEnum.man);
      notifier.setMajor(MajorEnum.sw);

      await notifier.submitSignup();

      expect(container.read(signupProvider).status, SignupStatus.failure);
      expect(container.read(signupProvider).emailError, '이미 가입된 이메일입니다.');
      expect(container.read(signupProvider).errorMessage, isNull);
    });
  });
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
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
  Future<ConfirmEmailVerificationResponseDto> confirmEmailVerification(
    ConfirmEmailVerificationRequestDto requestDto,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(SignUpRequestDto requestDto) {
    throw UnimplementedError();
  }

  @override
  Future<void> changePassword(ChangePasswordRequestDto requestDto) {
    throw UnimplementedError();
  }

  @override
  Future<SignInResponseDto> signIn(SignInRequestDto requestDto) {
    throw UnimplementedError();
  }

  @override
  Future<SignInResponseDto> reissue(String refreshToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut(String refreshToken) {
    throw UnimplementedError();
  }
}
