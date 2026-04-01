import 'package:goms/features/auth/session/domain/entities/auth_token_entity.dart';

abstract class SessionRepository {
  Future<AuthTokenEntity> signIn({
    required String email,
    required String password,
  });

  Future<AuthTokenEntity> reissue({
    required String refreshToken,
  });

  Future<void> signOut({
    required String refreshToken,
  });
}
