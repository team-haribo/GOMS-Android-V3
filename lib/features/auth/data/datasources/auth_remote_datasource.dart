import 'package:dio/dio.dart';
import 'package:goms/features/auth/data/dto/signin_request_dto.dart';
import 'package:goms/features/auth/data/dto/signin_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/api/v3/auth/signin')
  Future<SignInResponseDto> signIn(@Body() SignInRequestDto requestDto);
}
