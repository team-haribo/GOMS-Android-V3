import 'package:dio/dio.dart';
import 'package:goms/features/auth/email_verification/data/dto/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/signup/data/dto/signup/signup_request_dto.dart';

class SignupRemoteDataSource {
  const SignupRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> sendEmailVerification(
    SendEmailVerificationRequestDto requestDto,
  ) {
    return _dio.post<void>(
      '/api/v3/auth/email-verifications/send',
      data: requestDto.toJson(),
    );
  }

  Future<void> signUp(SignUpRequestDto requestDto) {
    return _dio.post<void>(
      '/api/v3/auth/signup',
      data: requestDto.toJson(),
    );
  }
}
