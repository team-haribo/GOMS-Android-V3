import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';
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

  testWidgets('권한 변경 후 바텀시트가 유지된다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memberRepositoryProvider.overrideWithValue(_FakeMemberRepository()),
          studentCouncilMembersProvider.overrideWith(
            _FakeStudentCouncilMembersNotifier.new,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: AdminOutingStateContainer(
              memberId: 2,
              name: '김민솔',
              grade: 8,
              major: 'AI',
              profileImageUrl: '',
              studentRole: StudentRole.student,
              status: 'COMING',
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();

    expect(find.text('유저 권한 변경'), findsOneWidget);
    expect(find.text('8기 | AI과'), findsOneWidget);
    expect(find.text('8학년 | AI'), findsNothing);

    await tester.tap(find.byType(Switch).last);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('유저 권한 변경'), findsOneWidget);
    expect(find.byType(Switch), findsWidgets);
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
        status: 'COMING',
      ),
      StudentCouncilStudentEntity(
        memberId: 2,
        name: '김민솔',
        grade: 8,
        department: 'AI',
        studentRole: StudentRole.student,
        status: 'COMING',
      ),
    ];
  }
}

class _FakeMemberRepository implements MemberRepository {
  @override
  Future<List<StudentCouncilStudentEntity>> getFilteredStudentCouncilMembers({
    required StudentCouncilFilterRequest filter,
  }) async {
    return const [];
  }

  @override
  Future<List<MemberEntity>> getMembers() async => const [];

  @override
  Future<List<StudentCouncilStudentEntity>> getStudentCouncilMembers({
    String? query,
  }) async {
    return const [
      StudentCouncilStudentEntity(
        memberId: 2,
        name: '김민솔',
        grade: 8,
        department: 'AI',
        studentRole: StudentRole.student,
        status: 'COMING',
      ),
    ];
  }

  @override
  Future<void> updateStudentCouncilOutingAllowed({
    required int memberId,
    required bool isAllowed,
  }) async {}

  @override
  Future<void> updateStudentCouncilRole({
    required int memberId,
    required bool isCouncil,
  }) async {}

  @override
  Future<void> withdrawMember({required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<String> updateProfileImage({required String imagePath}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProfileImage() {
    throw UnimplementedError();
  }

  @override
  Future<CurrentMemberEntity> getMyProfile() {
    throw UnimplementedError();
  }
}
