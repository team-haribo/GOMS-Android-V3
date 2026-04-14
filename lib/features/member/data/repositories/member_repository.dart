import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/ui/models/current_member_model.dart';
import 'package:goms/features/member/ui/models/member_model.dart';
import 'package:goms/features/member/ui/models/student_council_student_model.dart';

abstract class MemberRepository {
  Future<List<MemberModel>> getMembers();

  Future<CurrentMemberModel> getMyProfile();

  Future<List<StudentCouncilStudentModel>> getStudentCouncilMembers({
    String? query,
  });

  Future<List<StudentCouncilStudentModel>> getFilteredStudentCouncilMembers({
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

  Future<void> withdrawMember({required String password});
}
