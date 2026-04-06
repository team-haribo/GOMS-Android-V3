import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';
import 'package:goms/features/member/presentation/providers/student_council_members_provider.dart';

void main() {
  group('StudentCouncilMembersNotifier', () {
    test('updateMemberRole updates cached member role immediately', () async {
      final container = ProviderContainer(
        overrides: [
          memberRepositoryProvider.overrideWithValue(
            const _FakeMemberRepository(
              members: [
                StudentCouncilStudentEntity(
                  memberId: 1,
                  name: '김민솔',
                  grade: 8,
                  department: 'AI',
                  studentRole: StudentRole.student,
                ),
                StudentCouncilStudentEntity(
                  memberId: 2,
                  name: '류수연',
                  grade: 9,
                  department: 'SW',
                  studentRole: StudentRole.council,
                ),
              ],
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(studentCouncilMembersProvider.future);

      container.read(studentCouncilMembersProvider.notifier).updateMemberRole(
            memberId: 1,
            studentRole: StudentRole.outingBanned,
          );

      final members = container.read(studentCouncilMembersProvider).requireValue;

      expect(members.first.studentRole, StudentRole.outingBanned);
      expect(members.last.studentRole, StudentRole.council);
    });
  });
}

class _FakeMemberRepository implements MemberRepository {
  const _FakeMemberRepository({required this.members});

  final List<StudentCouncilStudentEntity> members;

  @override
  Future<List<StudentCouncilStudentEntity>> getStudentCouncilMembers({
    String? query,
  }) async {
    return members;
  }

  @override
  Future<List<StudentCouncilStudentEntity>> getFilteredStudentCouncilMembers({
    required StudentCouncilFilterRequest filter,
  }) async {
    return members;
  }

  @override
  Future<CurrentMemberEntity> getMyRole() {
    throw UnimplementedError();
  }

  @override
  Future<List<MemberEntity>> getMembers() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateStudentCouncilOutingAllowed({
    required int memberId,
    required bool isAllowed,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateStudentCouncilRole({
    required int memberId,
    required bool isCouncil,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> withdrawMember({required String password}) {
    throw UnimplementedError();
  }
}
