import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/widgets/common/text_fields/base_text_field.dart';
import '../test_app.dart';

void main() {
  testWidgets('BaseTextField shows custom error text when errorText exists', (
    WidgetTester tester,
  ) async {
    const errorMessage = 'invalid input';

    await tester.pumpWidget(
      buildTestApp(
        const BaseTextField(
          hintText: 'email',
          errorText: errorMessage,
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}

