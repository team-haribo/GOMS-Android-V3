import 'package:dio/dio.dart';
import 'package:goms/features/auth/email_verification/data/dto/email_verification/confirm_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/dto/email_verification/confirm_email_verification_response_dto.dart';
import 'package:goms/features/auth/email_verification/data/dto/email_verification/send_email_verification_request_dto.dart';

class EmailVerificationRemoteDataSource {
  const EmailVerificationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ConfirmEmailVerificationResponseDto> confirmEmailVerification(
    ConfirmEmailVerificationRequestDto requestDto,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v3/auth/email-verifications/confirm',
      data: requestDto.toJson(),
    );

    return ConfirmEmailVerificationResponseDto.fromJson(
      response.data ?? const {},
    );
  }

  Future<void> sendEmailVerification(
    SendEmailVerificationRequestDto requestDto,
  ) {
    return _dio.post<void>(
      '/api/v3/auth/email-verifications/send',
      data: requestDto.toJson(),
    );
  }
}
