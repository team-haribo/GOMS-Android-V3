import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:goms/features/auth/email_verification/data/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/signup/data/request/signup/signup_request_dto.dart';

part 'signup_remote_datasource.g.dart';

@RestApi()
abstract class SignupRemoteDataSource {
  factory SignupRemoteDataSource(Dio dio, {String? baseUrl}) =
      _SignupRemoteDataSource;

  @POST('/api/v3/auth/email-verifications/send')
  Future<void> sendEmailVerification(
    @Body() SendEmailVerificationRequestDto requestDto,
  );

  @POST('/api/v3/auth/signup')
  Future<void> signUp(@Body() SignUpRequestDto requestDto);
}
