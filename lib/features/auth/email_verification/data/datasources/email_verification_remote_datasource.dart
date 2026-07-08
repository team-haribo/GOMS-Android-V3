import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/confirm_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/models/response/email_verification/confirm_email_verification_response_dto.dart';

part 'email_verification_remote_datasource.g.dart';

@RestApi()
abstract class EmailVerificationRemoteDataSource {
  factory EmailVerificationRemoteDataSource(Dio dio, {String? baseUrl}) =
      _EmailVerificationRemoteDataSource;

  @POST('/api/v3/auth/email-verifications/confirm')
  Future<ConfirmEmailVerificationResponseDto> confirmEmailVerification(
    @Body() ConfirmEmailVerificationRequestDto requestDto,
  );

  @POST('/api/v3/auth/email-verifications/send')
  Future<void> sendEmailVerification(
    @Body() SendEmailVerificationRequestDto requestDto,
  );
}
