import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_setting/domain/enum/role_enum.dart';
import 'package:project_setting/widgets/common/buttons/toggle_button.dart';
import 'package:project_setting/widgets/common/text_fields/email_text_field.dart';
import 'package:project_setting/widgets/common/text_fields/password_text_field.dart';

void main() {
  testWidgets('auth widgets work together in a single form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const _AuthFormHarness());

    expect(find.text('@gsm.hs.kr'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'student');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility), findsOneWidget);

    final toggleFinder = find.byType(Switch);
    expect(tester.widget<Switch>(toggleFinder).value, isFalse);

    await tester.tap(toggleFinder);
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(toggleFinder).value, isTrue);
  });
}

class _AuthFormHarness extends StatefulWidget {
  const _AuthFormHarness();

  @override
  State<_AuthFormHarness> createState() => _AuthFormHarnessState();
}

class _AuthFormHarnessState extends State<_AuthFormHarness> {
  bool isUserEnabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const EmailTextField(),
              const SizedBox(height: 16),
              const PasswordTextField(),
              const SizedBox(height: 16),
              ToggleButton(
                type: RoleEnum.user,
                value: isUserEnabled,
                onChanged: (value) {
                  setState(() {
                    isUserEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
