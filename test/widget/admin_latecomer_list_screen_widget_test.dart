import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';
import 'package:goms/features/late/presentation/providers/student_council_late_students_provider.dart';
import 'package:goms/features/outing/presentation/screens/admin_latecomer_list_screen.dart';

void main() {
  testWidgets('AdminLatecomerListScreen renders late students for selected day',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.admin),
          studentCouncilLateDateProvider.overrideWith(
            (ref) => DateTime(2026, 4, 2),
          ),
          studentCouncilLateStudentsProvider.overrideWith(
            _FakeStudentCouncilLateStudentsNotifier.new,
          ),
        ],
        child: const MaterialApp(
          home: AdminLatecomerListScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('민준'), findsOneWidget);
    expect(find.text('서윤'), findsOneWidget);
    expect(find.text('2026년 4월 2일 (목)'), findsOneWidget);
  });
}

class _FakeStudentCouncilLateStudentsNotifier
    extends StudentCouncilLateStudentsNotifier {
  @override
  Future<List<LateRankStudentEntity>> build() async {
    return [
      LateRankStudentEntity(
        memberId: 1,
        name: '민준',
        grade: 8,
        department: 'AI',
        comingAt: DateTime(2026, 4, 2, 8, 30),
      ),
      LateRankStudentEntity(
        memberId: 2,
        name: '서윤',
        grade: 9,
        department: 'SW',
        comingAt: DateTime(2026, 4, 2, 8, 35),
      ),
    ];
  }
}
