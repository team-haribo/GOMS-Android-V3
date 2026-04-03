import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';
import 'package:goms/features/member/presentation/providers/student_council_members_provider.dart';
import 'package:goms/features/outing/presentation/screens/admin_outing_state_screen.dart';

void main() {
  testWidgets('AdminOutingStateScreen renders admin members and filters search',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.admin),
          studentCouncilMembersProvider.overrideWith(
            _FakeStudentCouncilMembersNotifier.new,
          ),
        ],
        child: const MaterialApp(
          home: AdminOutingStateScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('류수연'), findsOneWidget);
    expect(find.text('김민솔'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '민솔');
    await tester.pumpAndSettle();

    expect(find.text('김민솔'), findsOneWidget);
    expect(find.text('류수연'), findsNothing);
  });
}

class _FakeStudentCouncilMembersNotifier extends StudentCouncilMembersNotifier {
  @override
  Future<List<StudentCouncilStudentEntity>> build() async {
    return const [
      StudentCouncilStudentEntity(
        memberId: 1,
        name: '류수연',
        grade: 9,
        department: 'SW',
        studentRole: StudentRole.council,
      ),
      StudentCouncilStudentEntity(
        memberId: 2,
        name: '김민솔',
        grade: 8,
        department: 'AI',
        studentRole: StudentRole.student,
      ),
    ];
  }
}
