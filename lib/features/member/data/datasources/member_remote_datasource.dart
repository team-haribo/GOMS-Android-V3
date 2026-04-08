import 'package:dio/dio.dart';
import 'package:goms/features/member/data/response/current_member_dto.dart';
import 'package:goms/features/member/data/response/member_dto.dart';
import 'package:goms/features/member/data/response/profile_image_update_response.dart';
import 'package:goms/features/member/data/response/student_council_students_response.dart';
import 'package:retrofit/retrofit.dart';

part 'member_remote_datasource.g.dart';

@RestApi()
abstract class MemberRemoteDataSource {
  factory MemberRemoteDataSource(Dio dio, {String? baseUrl}) =
      _MemberRemoteDataSource;

  @GET('/members')
  Future<List<MemberDto>> getMembers();

  @GET('/api/v3/member/profile')
  Future<CurrentMemberDto> getMyProfile();

  @GET('/api/v3/student-council/member')
  Future<StudentCouncilStudentsResponse> getStudentCouncilMembers();

  @GET('/api/v3/student-council/search')
  Future<StudentCouncilStudentsResponse> searchStudentCouncilMembers(
    @Query('name') String name,
  );

  @GET('/api/v3/student-council/filter')
  Future<StudentCouncilStudentsResponse> filterStudentCouncilMembers(
    @Queries() Map<String, dynamic> filters,
  );

  @PATCH('/api/v3/student-council/role/{memberId}')
  Future<void> updateStudentCouncilRole(
    @Path('memberId') int memberId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/api/v3/student-council/outing-allowed/{memberId}')
  Future<void> updateStudentCouncilOutingAllowed(
    @Path('memberId') int memberId,
    @Body() Map<String, dynamic> body,
  );

  @MultiPart()
  @PATCH('/api/v3/member/profile-image')
  Future<ProfileImageUpdateResponse> updateProfileImage(
    @Part(name: 'image') MultipartFile image,
  );

  @DELETE('/api/v3/member/withdraw')
  Future<void> withdrawMember(@Body() Map<String, dynamic> body);
}
