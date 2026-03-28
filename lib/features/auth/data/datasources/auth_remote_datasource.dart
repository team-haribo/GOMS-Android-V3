import 'package:dio/dio.dart';
import 'package:goms/features/auth/data/dto/confirm_email_verification_request_dto.dart';
import 'package:goms/features/auth/data/dto/confirm_email_verification_response_dto.dart';
import 'package:goms/features/auth/data/dto/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/data/dto/signin_request_dto.dart';
import 'package:goms/features/auth/data/dto/signin_response_dto.dart';
import 'package:goms/features/auth/data/dto/signup_request_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/api/v3/auth/signin')
  Future<SignInResponseDto> signIn(@Body() SignInRequestDto requestDto);

  @POST('/api/v3/auth/email-verifications/send')
  Future<void> sendEmailVerification(
    @Body() SendEmailVerificationRequestDto requestDto,
  );

  @POST('/api/v3/auth/email-verifications/confirm')
  Future<ConfirmEmailVerificationResponseDto> confirmEmailVerification(
    @Body() ConfirmEmailVerificationRequestDto requestDto,
  );

  @POST('/api/v3/auth/signup')
  Future<void> signUp(@Body() SignUpRequestDto requestDto);
}
