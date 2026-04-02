import 'package:goms/features/auth/password_reset/data/datasources/password_reset_remote_datasource.dart';
import 'package:goms/features/auth/password_reset/data/request/password/change_password_request_dto.dart';
import 'package:goms/features/auth/password_reset/domain/repositories/password_reset_repository.dart';
import 'package:goms/features/auth/email_verification/data/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';

class PasswordResetRepositoryImpl implements PasswordResetRepository {
  const PasswordResetRepositoryImpl({
    required PasswordResetRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final PasswordResetRemoteDataSource _remoteDataSource;

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

  @override
  Future<void> changePassword({
    required String email,
    required String verifiedToken,
    required String newPassword,
  }) {
    return _remoteDataSource.changePassword(
      ChangePasswordRequestDto(
        email: email,
        verifiedToken: verifiedToken,
        newPassword: newPassword,
      ),
    );
  }
}
