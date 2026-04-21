import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/widgets/text_fields/search_text_field.dart';

void main() {
  testWidgets(
    'SearchTextField does not throw when mounted with an empty controller',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchTextField(),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.search), findsOneWidget);
    },
  );

  testWidgets(
    'SearchTextField reflects initial controller text without provider writes',
    (tester) async {
      final controller = TextEditingController(text: '분식');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchTextField(
              controller: controller,
              onBackPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(IconButton), findsOneWidget);

      controller.clear();
      await tester.pump();

      expect(find.byType(IconButton), findsNothing);
    },
  );
}
