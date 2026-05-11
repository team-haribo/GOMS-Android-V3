import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/data/repositories/member_repository.dart';
import 'package:goms/features/member/presentation/models/current_member_model.dart';
import 'package:goms/features/member/presentation/models/member_model.dart';
import 'package:goms/features/member/presentation/models/student_council_student_model.dart';
import 'package:goms/features/member/presentation/providers/student_council_members_provider.dart';

void main() {
  group('StudentCouncilMembersNotifier', () {
    test('updateMemberRole updates cached member role immediately', () async {
      final container = ProviderContainer(
        overrides: [
          memberRepositoryProvider.overrideWithValue(
            const _FakeMemberRepository(
              members: [
                StudentCouncilStudentModel(
                  memberId: 1,
                  name: '김민솔',
                  grade: 8,
                  department: 'AI',
                  studentRole: StudentRole.student,
                  status: 'COMING',
                ),
                StudentCouncilStudentModel(
                  memberId: 2,
                  name: '류수연',
                  grade: 9,
                  department: 'SW',
                  studentRole: StudentRole.council,
                  status: 'COMING',
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

      final members =
          container.read(studentCouncilMembersProvider).requireValue;

      expect(members.first.studentRole, StudentRole.outingBanned);
      expect(members.last.studentRole, StudentRole.council);
    });

    test('updateMemberStatus updates cached member status immediately',
        () async {
      final container = ProviderContainer(
        overrides: [
          memberRepositoryProvider.overrideWithValue(
            const _FakeMemberRepository(
              members: [
                StudentCouncilStudentModel(
                  memberId: 1,
                  name: '김민솔',
                  grade: 8,
                  department: 'AI',
                  studentRole: StudentRole.student,
                  status: 'COMING',
                ),
              ],
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(studentCouncilMembersProvider.future);

      container.read(studentCouncilMembersProvider.notifier).updateMemberStatus(
            memberId: 1,
            status: 'OUTING',
          );

      final members =
          container.read(studentCouncilMembersProvider).requireValue;

      expect(members.single.status, 'OUTING');
    });
  });
}

class _FakeMemberRepository implements MemberRepository {
  const _FakeMemberRepository({required this.members});

  final List<StudentCouncilStudentModel> members;

  @override
  Future<List<StudentCouncilStudentModel>> getStudentCouncilMembers({
    String? query,
  }) async {
    return members;
  }

  @override
  Future<List<StudentCouncilStudentModel>> getFilteredStudentCouncilMembers({
    required StudentCouncilFilterRequest filter,
  }) async {
    return members;
  }

  @override
  Future<List<MemberModel>> getMembers() {
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

  @override
  Future<String> updateProfileImage({required String imagePath}) {
    throw UnimplementedError();
  }

  @override
  Future<CurrentMemberModel> getMyProfile() {
    throw UnimplementedError();
  }
}
