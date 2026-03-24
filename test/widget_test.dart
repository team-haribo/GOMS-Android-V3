import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_app.dart';

void main() {
  testWidgets('MaterialApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const Text('smoke')));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('smoke'), findsOneWidget);
  });
}
