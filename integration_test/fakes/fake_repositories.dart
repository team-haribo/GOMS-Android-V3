import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_qr_result_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

/// CI 테스트 계정은 실제 외출 데이터가 비어있어서 outing_state_scroll perf
/// 시나리오가 스크롤할 대상이 없다. 측정용으로만 스크롤할 데이터를 채워주는
/// fake — 이 시나리오에서 쓰는 메서드만 구현하고 나머지는 UnimplementedError.
class FakeOutingRepository implements OutingRepository {
  static final List<OutingStudentEntity> _students = List.generate(
    30,
    (i) => OutingStudentEntity(
      memberId: i,
      name: '외출학생$i',
      grade: 1 + (i % 3),
      department: i % 2 == 0 ? 'SW' : 'AI',
      outingAt: DateTime(2026, 9, 18, 8, i % 60),
    ),
  );

  @override
  Future<List<OutingStudentEntity>> getCurrentOutingStudents() async =>
      _students;

  @override
  Future<List<OutingStudentEntity>> searchOutingStudents({
    required String name,
  }) async =>
      _students.where((s) => s.name.contains(name)).toList();

  @override
  Future<MyOutingStatusEntity> getMyOutingStatus() =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<OutingQrResultEntity> processOutingByQr({
    required String uuid,
    required int exp,
  }) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<OutingComingQrResultEntity> processComingByQr({
    required String uuid,
    required int exp,
  }) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<OutingQrResultEntity> forceOutStudent({required int memberId}) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<OutingComingQrResultEntity> forceInStudent({
    required int memberId,
  }) =>
      throw UnimplementedError('perf 테스트에서 안 씀');
}

/// member_list_scroll perf 시나리오용 — CI 테스트 계정이 보는 멤버 목록이
/// 비어있어서 스크롤할 데이터를 채워준다.
class FakeMemberRepository implements MemberRepository {
  static final List<MemberEntity> _members = List.generate(
    30,
    (i) => MemberEntity(
      id: i,
      name: '멤버$i',
      studentNumber: '${10 + i % 3}기 s${24000 + i}',
      role: 'ROLE_STUDENT',
      profileImageUrl: '',
    ),
  );

  @override
  Future<List<MemberEntity>> getMembers() async => _members;

  @override
  Future<CurrentMemberEntity> getMyProfile() async => const CurrentMemberEntity(
        memberId: 24068,
        email: 's24068@gsm.hs.kr',
        name: '테스트계정',
        role: RoleEnum.user,
      );

  @override
  Future<RoleEnum> getMyRole() async => RoleEnum.user;

  @override
  Future<List<StudentCouncilStudentEntity>> getStudentCouncilMembers({
    String? query,
  }) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<List<StudentCouncilStudentEntity>> getFilteredStudentCouncilMembers({
    required StudentCouncilFilterRequest filter,
  }) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<void> updateStudentCouncilRole({
    required int memberId,
    required bool isCouncil,
  }) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<void> updateStudentCouncilOutingAllowed({
    required int memberId,
    required bool isAllowed,
  }) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<String> updateProfileImage({required String imagePath}) =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<void> deleteProfileImage() =>
      throw UnimplementedError('perf 테스트에서 안 씀');

  @override
  Future<void> withdrawMember({required String password}) =>
      throw UnimplementedError('perf 테스트에서 안 씀');
}
