import 'package:goms/features/auth/session/data/datasources/session_remote_datasource.dart';
import 'package:goms/features/auth/session/data/request/signin/signin_request_dto.dart';
import 'package:goms/features/auth/session/data/response/signin/signin_response_dto.dart';
import 'package:goms/features/auth/session/domain/entities/auth_token_entity.dart';
import 'package:goms/features/auth/session/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl({
    required SessionRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final SessionRemoteDataSource _remoteDataSource;

  @override
  Future<AuthTokenEntity> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.signIn(
      SignInRequestDto(email: email, password: password),
    );
    return _toEntity(response);
  }

  @override
  Future<AuthTokenEntity> reissue({
    required String refreshToken,
  }) async {
    final response = await _remoteDataSource.reissue(
      _toBearerToken(refreshToken),
    );
    return _toEntity(response);
  }

  @override
  Future<void> signOut({
    required String refreshToken,
  }) {
    return _remoteDataSource.signOut(_toBearerToken(refreshToken));
  }

  String _toBearerToken(String token) {
    final trimmedToken = token.trim();
    if (trimmedToken.startsWith('Bearer ')) {
      return trimmedToken;
    }
    return 'Bearer $trimmedToken';
  }

  AuthTokenEntity _toEntity(SignInResponseDto response) {
    return AuthTokenEntity(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      accessTokenExpiresIn: response.accessTokenExpiresIn,
      refreshTokenExpiresIn: response.refreshTokenExpiresIn,
    );
  }
}
