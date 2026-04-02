import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:goms/features/auth/password_reset/data/request/password/change_password_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/request/email_verification/send_email_verification_request_dto.dart';

part 'password_reset_remote_datasource.g.dart';

@RestApi()
abstract class PasswordResetRemoteDataSource {
  factory PasswordResetRemoteDataSource(Dio dio, {String? baseUrl}) =
      _PasswordResetRemoteDataSource;

  @POST('/api/v3/auth/email-verifications/send')
  Future<void> sendEmailVerification(
    @Body() SendEmailVerificationRequestDto requestDto,
  );

  @PATCH('/api/v3/auth/password')
  Future<void> changePassword(@Body() ChangePasswordRequestDto requestDto);
}
