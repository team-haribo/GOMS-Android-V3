import 'package:dio/dio.dart';
import 'package:goms/core/auth/session_expiry_notifier.dart';
import 'package:goms/core/utils/token_storage.dart';

class AuthInterceptor extends Interceptor {
  static const _authPathPrefix = '/api/v3/auth';
  static const _authorizationHeader = 'Authorization';
  static const _refreshTokenHeader = 'RefreshToken';
  static const _didRetryKey = 'auth_retry_attempted';
  static const _skipUnauthorizedHandlingKey = 'skip_unauthorized_handling';

  AuthInterceptor({required Dio dio}) : _dio = dio;

  final Dio _dio;
  Future<String?>? _refreshTokenFuture;

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

    options.headers[_authorizationHeader] = _toBearerToken(accessToken);
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldHandleUnauthorized(
      err.requestOptions,
      err.response?.statusCode,
    )) {
      handler.next(err);
      return;
    }

    try {
      final refreshedToken = await _refreshAccessToken();
      if (refreshedToken == null || refreshedToken.isEmpty) {
        await _expireSession();
        handler.next(err);
        return;
      }

      final response = await _retryRequest(
        err.requestOptions,
        refreshedToken,
      );
      handler.resolve(response);
    } on _RefreshRejectedException {
      // 리프레시 토큰이 서버에서 실제로 거부된 경우에만 세션을 만료시킨다.
      await _expireSession();
      handler.next(err);
    } on DioException catch (_) {
      // 타임아웃·연결 끊김·서버 일시 오류 등은 토큰을 유지하고
      // 현재 요청만 실패 처리한다. (다음 요청에서 다시 재발급을 시도)
      handler.next(err);
    } catch (_) {
      // 예기치 못한 오류에서도 세션은 보존한다.
      handler.next(err);
    }
  }

  bool _shouldSkipAuthorization(RequestOptions options) {
    if (options.headers.containsKey(_authorizationHeader)) {
      return true;
    }

    return options.path.startsWith(_authPathPrefix);
  }

  bool _shouldHandleUnauthorized(RequestOptions options, int? statusCode) {
    if (statusCode != 401) {
      return false;
    }

    if (options.path.startsWith(_authPathPrefix)) {
      return false;
    }

    if (options.extra[_didRetryKey] == true ||
        options.extra[_skipUnauthorizedHandlingKey] == true) {
      return false;
    }

    return true;
  }

  String _toBearerToken(String token) {
    final trimmedToken = token.trim();
    if (trimmedToken.startsWith('Bearer ')) {
      return trimmedToken;
    }
    return 'Bearer $trimmedToken';
  }

  Future<String?> _refreshAccessToken() async {
    final inFlightRequest = _refreshTokenFuture;
    if (inFlightRequest != null) {
      return inFlightRequest;
    }

    final completer = Future<String?>(() async {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.trim().isEmpty) {
        return null;
      }

      final Response<Map<String, dynamic>> response;
      try {
        response = await _dio.patch<Map<String, dynamic>>(
          '$_authPathPrefix/reissue',
          options: Options(
            headers: {_refreshTokenHeader: _toBearerToken(refreshToken)},
            extra: {_skipUnauthorizedHandlingKey: true},
          ),
        );
      } on DioException catch (error) {
        if (_isRefreshRejected(error)) {
          // 서버가 401/403으로 리프레시 토큰을 명시적으로 거부 → 만료 처리
          throw const _RefreshRejectedException();
        }
        // 그 외(타임아웃·연결 오류·5xx 등)는 일시 장애로 보고 그대로 전파해
        // 세션을 유지한다.
        rethrow;
      }

      final data = response.data ?? const <String, dynamic>{};
      final nextAccessToken = (data['accessToken'] as String?)?.trim();
      final nextRefreshToken = (data['refreshToken'] as String?)?.trim();
      final accessTokenExpiry = DateTime.tryParse(
        (data['accessTokenExpiresIn'] as String?) ?? '',
      )?.toUtc();
      final refreshTokenExpiry = DateTime.tryParse(
        (data['refreshTokenExpiresIn'] as String?) ?? '',
      )?.toUtc();

      if (nextAccessToken == null || nextAccessToken.isEmpty) {
        // 서버가 2xx를 주고도 토큰을 누락한 경우는 서버 측 이상으로 보고
        // 세션을 만료시키지 않는다. (리프레시 토큰은 아직 유효할 수 있음)
        throw const _RefreshMalformedException();
      }

      await TokenStorage.saveAccessToken(nextAccessToken);
      if (nextRefreshToken != null && nextRefreshToken.isNotEmpty) {
        await TokenStorage.saveRefreshToken(nextRefreshToken);
      }
      if (accessTokenExpiry != null) {
        await TokenStorage.saveAccessTokenExpiry(accessTokenExpiry);
      }
      if (refreshTokenExpiry != null) {
        await TokenStorage.saveRefreshTokenExpiry(refreshTokenExpiry);
      }

      return nextAccessToken;
    });

    _refreshTokenFuture = completer;
    try {
      return await completer;
    } finally {
      if (identical(_refreshTokenFuture, completer)) {
        _refreshTokenFuture = null;
      }
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    final headers = Map<String, dynamic>.from(requestOptions.headers)
      ..[_authorizationHeader] = _toBearerToken(accessToken);
    final extra = Map<String, dynamic>.from(requestOptions.extra)
      ..[_didRetryKey] = true;

    final options = Options(
      method: requestOptions.method,
      headers: headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: extra,
      followRedirects: requestOptions.followRedirects,
      listFormat: requestOptions.listFormat,
      maxRedirects: requestOptions.maxRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      receiveTimeout: requestOptions.receiveTimeout,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      sendTimeout: requestOptions.sendTimeout,
      validateStatus: requestOptions.validateStatus,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }

  bool _isRefreshRejected(DioException error) {
    final statusCode = error.response?.statusCode;
    return statusCode == 401 || statusCode == 403;
  }

  Future<void> _expireSession() async {
    await TokenStorage.deleteAllTokens();
    await SessionExpiryNotifier.notify();
  }
}

/// 리프레시 토큰이 서버에서 실제로 거부(401/403)되었음을 나타낸다.
/// 일시적 네트워크/서버 오류와 구분해 세션 만료 여부를 결정하기 위해 사용한다.
class _RefreshRejectedException implements Exception {
  const _RefreshRejectedException();
}

/// 재발급 응답이 2xx임에도 토큰이 비어 있는 비정상 응답을 나타낸다.
/// 일시적 서버 이상으로 보고 세션을 유지한다.
class _RefreshMalformedException implements Exception {
  const _RefreshMalformedException();
}
