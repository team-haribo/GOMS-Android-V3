import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/auth/session_expiry_notifier.dart';
import 'package:goms/core/network/auth_interceptor.dart';
import 'package:goms/features/auth/session/data/datasources/session_remote_datasource.dart';
import 'package:goms/features/auth/session/data/repositories/session_repository_impl.dart';
import 'package:goms/features/auth/session/data/request/signin/signin_request_dto.dart';
import 'package:goms/features/auth/session/data/response/signin/signin_response_dto.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  final storage = <String, String?>{};

  Future<Object?> secureStorageHandler(MethodCall call) async {
    final arguments = Map<String, dynamic>.from(
      (call.arguments as Map?)?.cast<String, dynamic>() ?? const {},
    );
    final key = arguments['key'] as String?;

    switch (call.method) {
      case 'read':
        return storage[key];
      case 'write':
        if (key != null) {
          storage[key] = arguments['value'] as String?;
        }
        return null;
      case 'delete':
        if (key != null) {
          storage.remove(key);
        }
        return null;
      case 'deleteAll':
        storage.clear();
        return null;
      default:
        return null;
    }
  }

  setUp(() {
    storage.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, secureStorageHandler);
  });

  tearDown(() {
    storage.clear();
    SessionExpiryNotifier.unregister(_sessionExpiryCallback);
    _sessionExpiryTriggered = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

  group('AuthInterceptor', () {
    test('adds Authorization bearer header to non-auth requests', () async {
      storage['access_token'] = 'access-token';
      final options = RequestOptions(path: '/api/v3/members/me');
      final handler = _VisibleRequestHandler();

      await AuthInterceptor(dio: Dio()).onRequest(options, handler);
      final request = await handler.nextRequest;

      expect(request.headers['Authorization'], 'Bearer access-token');
    });

    test('preserves an existing Authorization header', () async {
      storage['access_token'] = 'access-token';
      final options = RequestOptions(
        path: '/api/v3/members/me',
        headers: {'Authorization': 'Bearer override-token'},
      );
      final handler = _VisibleRequestHandler();

      await AuthInterceptor(dio: Dio()).onRequest(options, handler);
      final request = await handler.nextRequest;

      expect(request.headers['Authorization'], 'Bearer override-token');
    });

    test('skips Authorization header injection on auth endpoints', () async {
      storage['access_token'] = 'access-token';
      final options = RequestOptions(path: '/api/v3/auth/signin');
      final handler = _VisibleRequestHandler();

      await AuthInterceptor(dio: Dio()).onRequest(options, handler);
      final request = await handler.nextRequest;

      expect(request.headers.containsKey('Authorization'), isFalse);
    });

    test('reissues tokens and retries the original request after a 401',
        () async {
      storage['access_token'] = 'expired-access-token';
      storage['refresh_token'] = 'refresh-token';

      final adapter = _QueueHttpClientAdapter([
        _QueuedResponse(
          matcher: (options) =>
              options.path == '/api/v3/place/recommend/1' &&
              options.headers['Authorization'] == 'Bearer expired-access-token',
          statusCode: 401,
        ),
        _QueuedResponse(
          matcher: (options) =>
              options.path == '/api/v3/auth/reissue' &&
              options.headers['RefreshToken'] == 'Bearer refresh-token',
          statusCode: 200,
          data: {
            'accessToken': 'renewed-access-token',
            'refreshToken': 'renewed-refresh-token',
            'accessTokenExpiresIn': '2026-12-31T00:00:00.000Z',
            'refreshTokenExpiresIn': '2027-01-31T00:00:00.000Z',
          },
        ),
        _QueuedResponse(
          matcher: (options) =>
              options.path == '/api/v3/place/recommend/1' &&
              options.headers['Authorization'] ==
                  'Bearer renewed-access-token' &&
              options.extra['auth_retry_attempted'] == true,
          statusCode: 200,
          data: {'recommended': true},
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(dio: dio));

      final response = await dio.post<Map<String, dynamic>>(
        '/api/v3/place/recommend/1',
      );

      expect(response.statusCode, 200);
      expect(response.data?['recommended'], true);
      expect(storage['access_token'], 'renewed-access-token');
      expect(storage['refresh_token'], 'renewed-refresh-token');
      expect(adapter.requests.length, 3);
    });

    test('clears tokens and notifies session expiry when reissue fails',
        () async {
      storage['access_token'] = 'expired-access-token';
      storage['refresh_token'] = 'expired-refresh-token';
      SessionExpiryNotifier.register(_sessionExpiryCallback);

      final adapter = _QueueHttpClientAdapter([
        _QueuedResponse(
          matcher: (options) => options.path == '/api/v3/place/recommend/1',
          statusCode: 401,
        ),
        _QueuedResponse(
          matcher: (options) => options.path == '/api/v3/auth/reissue',
          statusCode: 401,
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(AuthInterceptor(dio: dio));

      await expectLater(
        () => dio.post<Map<String, dynamic>>('/api/v3/place/recommend/1'),
        throwsA(isA<DioException>()),
      );

      expect(storage['access_token'], isNull);
      expect(storage['refresh_token'], isNull);
      expect(_sessionExpiryTriggered, isTrue);
    });
  });

  group('SessionRepositoryImpl', () {
    test('reissue prefixes refresh tokens with Bearer', () async {
      final remoteDataSource = _FakeSessionRemoteDataSource();
      final repository = SessionRepositoryImpl(
        remoteDataSource: remoteDataSource,
      );

      await repository.reissue(refreshToken: 'refresh-token');

      expect(remoteDataSource.reissueRefreshToken, 'Bearer refresh-token');
    });

    test('signOut keeps existing Bearer refresh tokens unchanged', () async {
      final remoteDataSource = _FakeSessionRemoteDataSource();
      final repository = SessionRepositoryImpl(
        remoteDataSource: remoteDataSource,
      );

      await repository.signOut(refreshToken: 'Bearer refresh-token');

      expect(remoteDataSource.signOutRefreshToken, 'Bearer refresh-token');
    });
  });
}

bool _sessionExpiryTriggered = false;

Future<void> _sessionExpiryCallback() async {
  _sessionExpiryTriggered = true;
}

class _VisibleRequestHandler extends RequestInterceptorHandler {
  Future<RequestOptions> get nextRequest async {
    final state = await future;
    return state.data as RequestOptions;
  }
}

class _FakeSessionRemoteDataSource implements SessionRemoteDataSource {
  String? reissueRefreshToken;
  String? signOutRefreshToken;

  @override
  Future<SignInResponseDto> reissue(String refreshToken) async {
    reissueRefreshToken = refreshToken;
    return SignInResponseDto(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      accessTokenExpiresIn: DateTime(2026),
      refreshTokenExpiresIn: DateTime(2026),
    );
  }

  @override
  Future<void> signOut(String refreshToken) async {
    signOutRefreshToken = refreshToken;
  }

  @override
  Future<SignInResponseDto> signIn(SignInRequestDto requestDto) {
    throw UnimplementedError();
  }
}

class _QueueHttpClientAdapter implements HttpClientAdapter {
  _QueueHttpClientAdapter(this._responses);

  final List<_QueuedResponse> _responses;
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (_responses.isEmpty) {
      throw StateError(
        'No queued response for ${options.method} ${options.path}',
      );
    }

    final response = _responses.removeAt(0);
    if (!response.matcher(options)) {
      throw StateError(
        'Unexpected request order: ${options.method} ${options.path} '
        'headers=${options.headers}',
      );
    }

    final bytes = utf8.encode(jsonEncode(response.data ?? const {}));
    return ResponseBody.fromBytes(
      bytes,
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _QueuedResponse {
  const _QueuedResponse({
    required this.matcher,
    required this.statusCode,
    this.data,
  });

  final bool Function(RequestOptions options) matcher;
  final int statusCode;
  final Map<String, dynamic>? data;
}
