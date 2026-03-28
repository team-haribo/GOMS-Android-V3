import 'package:goms/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:goms/features/auth/data/dto/signin_request_dto.dart';
import 'package:goms/features/auth/data/dto/signin_response_dto.dart';
import 'package:goms/features/auth/data/dto/signup_request_dto.dart';

class AuthRepository {
  AuthRepository({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  Future<SignInResponseDto> signIn({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signIn(
      SignInRequestDto(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signUp({
    required String email,
    required String verifiedToken,
    required String password,
    required String name,
    required int grade,
    required String department,
    required String gender,
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
