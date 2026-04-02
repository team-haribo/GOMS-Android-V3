import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';

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
    required DepartmentType department,
    required GenderType gender,
  });
}
