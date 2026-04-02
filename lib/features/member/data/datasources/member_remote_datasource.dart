import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:goms/features/member/data/response/current_member_dto.dart';
import 'package:goms/features/member/data/response/member_dto.dart';

part 'member_remote_datasource.g.dart';

@RestApi()
abstract class MemberRemoteDataSource {
  factory MemberRemoteDataSource(Dio dio, {String? baseUrl}) =
      _MemberRemoteDataSource;

  @GET('/members')
  Future<List<MemberDto>> getMembers();

  @GET('/api/v3/member/myrole')
  Future<CurrentMemberDto> getMyRole();

  @DELETE('/api/v3/member/withdraw')
  Future<void> withdrawMember(@Body() Map<String, dynamic> body);
}
