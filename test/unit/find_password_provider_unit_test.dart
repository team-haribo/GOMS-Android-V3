import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/auth/password_reset/presentation/models/find_password_state.dart';
import 'package:goms/features/auth/password_reset/presentation/providers/find_password_provider.dart';

void main() {
  group('FindPasswordNotifier', () {
    test('validateEmail updates state and form validity', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(findPasswordProvider.notifier);

      notifier.validateEmail('bad');
      expect(container.read(findPasswordProvider).emailError, isNotNull);
      expect(notifier.isFormValid, isFalse);

      notifier.validateEmail('s2201');
      expect(container.read(findPasswordProvider).emailError, isNull);
      expect(notifier.isFormValid, isTrue);
    });

    test('findPassword sets failure when email format is invalid', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(findPasswordProvider.notifier);

      notifier.validateEmail('wrong');
      await notifier.findPassword();

      final state = container.read(findPasswordProvider);
      expect(state.status, FindPasswordStatus.failure);
      expect(state.emailError, isNotNull);
    });
  });
}
