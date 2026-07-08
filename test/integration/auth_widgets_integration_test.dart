import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/widgets/buttons/toggle_button.dart';
import 'package:goms_design_system/goms_design_system.dart';
import '../test_app.dart';

final _authHarnessToggleProvider =
    NotifierProvider.autoDispose<_AuthHarnessToggleNotifier, bool>(
  _AuthHarnessToggleNotifier.new,
);

class _AuthHarnessToggleNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setEnabled(bool value) => state = value;
}

void main() {
  const emailFieldKey = Key('email_field');
  const passwordFieldKey = Key('password_field');

  testWidgets('auth widgets work together in a single form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const _AuthFormHarness(
          emailFieldKey: emailFieldKey,
          passwordFieldKey: passwordFieldKey,
        ),
      ),
    );

    expect(find.text('@gsm.hs.kr'), findsOneWidget);

    await tester.enterText(find.byKey(emailFieldKey), 'student');
    await tester.enterText(find.byKey(passwordFieldKey), 'secret123');

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    final toggleFinder = find.byType(Switch);
    expect(tester.widget<Switch>(toggleFinder).value, isFalse);

    await tester.tap(toggleFinder);
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(toggleFinder).value, isTrue);
  });
}

class _AuthFormHarness extends ConsumerWidget {
  const _AuthFormHarness({
    required this.emailFieldKey,
    required this.passwordFieldKey,
  });

  final Key emailFieldKey;
  final Key passwordFieldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserEnabled = ref.watch(_authHarnessToggleProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          EmailTextField(key: emailFieldKey),
          const SizedBox(height: 16),
          PasswordTextField(key: passwordFieldKey),
          const SizedBox(height: 16),
          ToggleButton(
            type: RoleEnum.user,
            value: isUserEnabled,
            onChanged: (value) =>
                ref.read(_authHarnessToggleProvider.notifier).setEnabled(value),
          ),
        ],
      ),
    );
  }
}
