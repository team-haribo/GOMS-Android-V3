import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/widgets/avatars/profile_avatar.dart';

void main() {
  group('ProfileAvatar', () {
    testWidgets('shows default avatar immediately when image url is empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(
              radius: 24,
              imageUrl: '',
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ProfileAvatar), findsOneWidget);
    });

    testWidgets('shows loading indicator instead of default-looking avatar '
        'while remote image is loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(
              radius: 24,
              imageUrl: 'https://example.com/profile.png',
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
