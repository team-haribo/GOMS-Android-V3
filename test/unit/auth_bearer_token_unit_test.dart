import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

  group('AuthInterceptor', () {
    test('adds Authorization bearer header to non-auth requests', () async {
      storage['access_token'] = 'access-token';
      final options = RequestOptions(path: '/api/v3/members/me');
      final handler = _VisibleRequestHandler();

      await AuthInterceptor().onRequest(options, handler);
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

      await AuthInterceptor().onRequest(options, handler);
      final request = await handler.nextRequest;

      expect(request.headers['Authorization'], 'Bearer override-token');
    });

    test('skips Authorization header injection on auth endpoints', () async {
      storage['access_token'] = 'access-token';
      final options = RequestOptions(path: '/api/v3/auth/signin');
      final handler = _VisibleRequestHandler();

      await AuthInterceptor().onRequest(options, handler);
      final request = await handler.nextRequest;

      expect(request.headers.containsKey('Authorization'), isFalse);
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
