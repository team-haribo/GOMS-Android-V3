import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';

abstract class MemberRepository {
  Future<List<MemberEntity>> getMembers();

  Future<CurrentMemberEntity> getMyProfile();

  /// 서버 DB 기준 최신 권한을 조회한다. access token의 role claim이 아니라
  /// 서버가 보관한 role을 반환하므로 동기화 직후 stale 권한 보정에 사용한다.
  Future<RoleEnum> getMyRole();

  Future<List<StudentCouncilStudentEntity>> getStudentCouncilMembers({
    String? query,
  });

  Future<List<StudentCouncilStudentEntity>> getFilteredStudentCouncilMembers({
    required StudentCouncilFilterRequest filter,
  });

  Future<void> updateStudentCouncilRole({
    required int memberId,
    required bool isCouncil,
  });

  Future<void> updateStudentCouncilOutingAllowed({
    required int memberId,
    required bool isAllowed,
  });

  Future<String> updateProfileImage({required String imagePath});

  Future<void> deleteProfileImage();

  Future<void> withdrawMember({required String password});
}
