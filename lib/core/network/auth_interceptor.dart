import 'package:dio/dio.dart';
import 'package:goms/core/utils/token_storage.dart';

class AuthInterceptor extends Interceptor {
  static const _authPathPrefix = '/api/v3/auth';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldSkipAuthorization(options)) {
      handler.next(options);
      return;
    }

    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      handler.next(options);
      return;
    }

    options.headers['Authorization'] = _toBearerToken(accessToken);
    handler.next(options);
  }

  bool _shouldSkipAuthorization(RequestOptions options) {
    if (options.headers.containsKey('Authorization')) {
      return true;
    }

    return options.path.startsWith(_authPathPrefix);
  }

  String _toBearerToken(String token) {
    final trimmedToken = token.trim();
    if (trimmedToken.startsWith('Bearer ')) {
      return trimmedToken;
    }
    return 'Bearer $trimmedToken';
  }
}
