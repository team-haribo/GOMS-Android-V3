import 'package:goms/features/auth/email_verification/data/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/signup/data/datasources/signup_remote_datasource.dart';
import 'package:goms/features/auth/signup/data/request/signup/signup_request_dto.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/features/auth/signup/domain/repositories/signup_repository.dart';

class SignupRepositoryImpl implements SignupRepository {
  const SignupRepositoryImpl({
    required SignupRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final SignupRemoteDataSource _remoteDataSource;

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
  Future<void> signUp({
    required String email,
    required String verifiedToken,
    required String password,
    required String name,
    required int grade,
    required DepartmentType department,
    required GenderType gender,
  }) {
    return _remoteDataSource.signUp(
      SignUpRequestDto(
        email: email,
        verifiedToken: verifiedToken,
        password: password,
        name: name,
        grade: grade,
        department: department,
        gender: gender,
      ),
    );
  }
}
