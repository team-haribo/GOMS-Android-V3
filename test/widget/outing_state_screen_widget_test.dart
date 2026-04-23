import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/features/outing/ui/models/outing_student_model.dart';
import 'package:goms/features/outing/ui/screens/outing_state_screen.dart';
import 'package:goms/features/outing/ui/providers/current_outing_students_provider.dart';

void main() {
  testWidgets('OutingStateScreen renders current outing students from provider',
      (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
          currentOutingStudentsProvider.overrideWith(
            _FakeCurrentOutingStudentsNotifier.new,
          ),
        ],
        child: const MaterialApp(
          home: OutingStateScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('이주언'), findsOneWidget);
    expect(find.text('김민솔'), findsOneWidget);
    expect(find.text('8기 | AI과'), findsOneWidget);
    expect(find.text('9기 | SW과'), findsOneWidget);
    expect(find.text('9학년 | SW'), findsNothing);
  });

  testWidgets('OutingStateScreen filters students by search text',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
          currentOutingStudentsProvider.overrideWith(
            _FakeCurrentOutingStudentsNotifier.new,
          ),
        ],
        child: const MaterialApp(
          home: OutingStateScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '민솔');
    await tester.pumpAndSettle();

    expect(find.text('김민솔'), findsOneWidget);
    expect(find.text('이주언'), findsNothing);
  });
}

class _FakeCurrentOutingStudentsNotifier extends CurrentOutingStudentsNotifier {
  @override
  Future<List<OutingStudentModel>> build() async {
    return [
      OutingStudentModel(
        memberId: 1,
        name: '이주언',
        grade: 8,
        department: 'AI',
        outingAt: DateTime(2026, 4, 2, 10, 30),
      ),
      OutingStudentModel(
        memberId: 2,
        name: '김민솔',
        grade: 9,
        department: 'SW',
        outingAt: DateTime(2026, 4, 2, 11, 0),
      ),
    ];
  }
}
