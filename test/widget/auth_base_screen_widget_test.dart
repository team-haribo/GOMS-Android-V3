import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_setting/presentation/auth/auth_base_screen.dart';

void main() {
  testWidgets('confirm button is disabled when form is invalid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AuthBaseScreen(
            title: 'Auth',
            confirmText: 'Confirm',
            onConfirm: _noop,
            isConfirmEnabled: false,
            children: [],
          ),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('loading state shows progress indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AuthBaseScreen(
            title: 'Auth',
            confirmText: 'Confirm',
            onConfirm: _noop,
            isConfirmEnabled: true,
            isLoading: true,
            children: [],
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Confirm'), findsNothing);
  });
}

void _noop() {}

