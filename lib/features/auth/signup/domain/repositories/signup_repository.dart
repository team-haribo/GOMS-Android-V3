import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';

abstract class SignupRepository {
  Future<void> sendEmailVerification({
    required String email,
    required EmailVerificationPurpose purpose,
  });

  Future<void> signUp({
    required String email,
    required String verifiedToken,
    required String password,
    required String name,
    required int grade,
    required String department,
    required String gender,
  });
}
