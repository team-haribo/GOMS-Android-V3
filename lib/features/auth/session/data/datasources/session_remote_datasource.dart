import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:goms/features/auth/session/data/dto/signin/signin_request_dto.dart';
import 'package:goms/features/auth/session/data/dto/signin/signin_response_dto.dart';

part 'session_remote_datasource.g.dart';

@RestApi()
abstract class SessionRemoteDataSource {
  factory SessionRemoteDataSource(Dio dio, {String? baseUrl}) =
      _SessionRemoteDataSource;

  @POST('/api/v3/auth/signin')
  Future<SignInResponseDto> signIn(@Body() SignInRequestDto requestDto);

  @PATCH('/api/v3/auth/reissue')
  Future<SignInResponseDto> reissue(
    @Header('RefreshToken') String refreshToken,
  );

  @DELETE('/api/v3/auth/signout')
  Future<void> signOut(@Header('RefreshToken') String refreshToken);
}
