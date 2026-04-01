class AuthTokenEntity {
  const AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    required this.refreshTokenExpiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresIn;
  final DateTime refreshTokenExpiresIn;
}
