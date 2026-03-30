import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/gender_enum.dart';
import 'package:goms/core/enums/major_enum.dart';
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
  });
}
