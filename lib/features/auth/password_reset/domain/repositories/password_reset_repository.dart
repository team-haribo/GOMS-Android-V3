import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';

abstract class PasswordResetRepository {
  Future<void> sendEmailVerification({
    required String email,
    required EmailVerificationPurpose purpose,
  });

  Future<void> changePassword({
    required String email,
    required String verifiedToken,
    required String newPassword,
  });
}
