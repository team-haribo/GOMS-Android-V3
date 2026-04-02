import 'package:goms/features/auth/email_verification/data/datasources/email_verification_remote_datasource.dart';
import 'package:goms/features/auth/email_verification/data/request/email_verification/confirm_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/response/email_verification/confirm_email_verification_response_dto.dart';
import 'package:goms/features/auth/email_verification/domain/entities/email_verification_entity.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/email_verification/domain/repositories/email_verification_repository.dart';

class EmailVerificationRepositoryImpl implements EmailVerificationRepository {
  const EmailVerificationRepositoryImpl({
    required EmailVerificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final EmailVerificationRemoteDataSource _remoteDataSource;

  @override
  Future<EmailVerificationEntity> confirmEmailVerification({
    required String email,
    required String code,
    required EmailVerificationPurpose purpose,
  }) async {
    final response = await _remoteDataSource.confirmEmailVerification(
      ConfirmEmailVerificationRequestDto(
        email: email,
        code: code,
        purpose: purpose,
      ),
    );
    return _toEntity(response);
  }

  @override
  Future<void> sendEmailVerification({
    required String email,
    required EmailVerificationPurpose purpose,
  }) {
    return _remoteDataSource.sendEmailVerification(
      SendEmailVerificationRequestDto(
        email: email,
        purpose: purpose,
      ),
    );
  }

  EmailVerificationEntity _toEntity(
    ConfirmEmailVerificationResponseDto response,
  ) {
    return EmailVerificationEntity(verifiedToken: response.verifiedToken);
  }
}
