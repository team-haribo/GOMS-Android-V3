import 'package:dio/dio.dart';
import 'package:goms/features/auth/password_reset/data/dto/password/change_password_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/dto/email_verification/send_email_verification_request_dto.dart';

class PasswordResetRemoteDataSource {
  const PasswordResetRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> sendEmailVerification(
    SendEmailVerificationRequestDto requestDto,
  ) {
    return _dio.post<void>(
      '/api/v3/auth/email-verifications/send',
      data: requestDto.toJson(),
    );
  }

  Future<void> changePassword(ChangePasswordRequestDto requestDto) {
    return _dio.patch<void>(
      '/api/v3/auth/password',
      data: requestDto.toJson(),
    );
  }
}
