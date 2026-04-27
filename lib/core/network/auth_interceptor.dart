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
    } on DioException catch (_) {
      await _expireSession();
      handler.next(err);
    } catch (_) {
      await _expireSession();
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

      final response = await _dio.patch<Map<String, dynamic>>(
        '$_authPathPrefix/reissue',
        options: Options(
          headers: {_refreshTokenHeader: _toBearerToken(refreshToken)},
          extra: {_skipUnauthorizedHandlingKey: true},
        ),
      );

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
        return null;
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

  Future<void> _expireSession() async {
    await TokenStorage.deleteAllTokens();
    await SessionExpiryNotifier.notify();
  }
}
