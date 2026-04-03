import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';

abstract class MemberRepository {
  Future<List<MemberEntity>> getMembers();
  Future<CurrentMemberEntity> getMyRole();
  Future<List<StudentCouncilStudentEntity>> getStudentCouncilMembers({
    String? query,
  });
  Future<void> updateStudentCouncilRole({
    required int memberId,
    required bool isCouncil,
  });
  Future<void> updateStudentCouncilOutingAllowed({
    required int memberId,
    required bool isAllowed,
  });
  Future<void> withdrawMember({required String password});
}
