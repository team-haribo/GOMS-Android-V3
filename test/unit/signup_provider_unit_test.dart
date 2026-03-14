import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/gender_enum.dart';
import 'package:goms/core/enums/major_enum.dart';
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
  });
}
