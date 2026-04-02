import 'package:goms/features/auth/email_verification/domain/entities/email_verification_entity.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';

abstract class EmailVerificationRepository {
  Future<EmailVerificationEntity> confirmEmailVerification({
    required String email,
    required String code,
    required EmailVerificationPurpose purpose,
  });

  Future<void> sendEmailVerification({
    required String email,
    required EmailVerificationPurpose purpose,
  });
}
