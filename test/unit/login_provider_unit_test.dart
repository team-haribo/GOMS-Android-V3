import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/auth/session/data/datasources/session_remote_datasource.dart';
import 'package:goms/features/auth/session/data/request/signin/signin_request_dto.dart';
import 'package:goms/features/auth/session/data/response/signin/signin_response_dto.dart';
import 'package:goms/features/auth/session/data/providers/session_data_providers.dart';
import 'package:goms/features/auth/session/data/repositories/session_repository_impl.dart';
import 'package:goms/features/auth/login/presentation/models/login_state.dart';
import 'package:goms/features/auth/login/presentation/providers/login_provider.dart';

void main() {
  group('LoginNotifier', () {
    test('login email validation rejects domain input', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(loginProvider.notifier);
      notifier.validateEmail('s24068@gsm.hs.kr');

      final state = container.read(loginProvider);
      expect(state.emailError, '잘못된 형식의 이메일입니다.');
    });

    test('404 login failure maps to email error', () async {
      final container = ProviderContainer(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(
            SessionRepositoryImpl(
              remoteDataSource: _FakeAuthRemoteDataSource(
                signInException: _dioException(statusCode: 404),
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(loginProvider.notifier)
          .login('s24068', 'jueon2008!');

      final state = container.read(loginProvider);
      expect(state.status, LoginStatus.failure);
      expect(state.emailError, '가입되지 않은 이메일입니다.');
      expect(state.passwordError, isNull);
      expect(state.errorMessage, isNull);
    });

    test('403 login failure maps to password error', () async {
      final container = ProviderContainer(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(
            SessionRepositoryImpl(
              remoteDataSource: _FakeAuthRemoteDataSource(
                signInException: _dioException(statusCode: 403),
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(loginProvider.notifier)
          .login('s24068', 'jueon2008!');

      final state = container.read(loginProvider);
      expect(state.status, LoginStatus.failure);
      expect(state.emailError, isNull);
      expect(state.passwordError, '비밀번호가 일치하지 않습니다.');
      expect(state.errorMessage, isNull);
    });
  });
}

DioException _dioException({required int statusCode}) {
  return DioException(
    requestOptions: RequestOptions(path: '/api/v3/auth/signin'),
    response: Response<void>(
      requestOptions: RequestOptions(path: '/api/v3/auth/signin'),
      statusCode: statusCode,
    ),
  );
}

class _FakeAuthRemoteDataSource implements SessionRemoteDataSource {
  _FakeAuthRemoteDataSource({this.signInException});

  final DioException? signInException;

  @override
  Future<SignInResponseDto> signIn(SignInRequestDto requestDto) async {
    if (signInException != null) {
      throw signInException!;
    }

    return SignInResponseDto(
      accessToken: 'access',
      refreshToken: 'refresh',
      accessTokenExpiresIn: DateTime(2026),
      refreshTokenExpiresIn: DateTime(2026),
    );
  }

  @override
  Future<SignInResponseDto> reissue(String refreshToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut(String refreshToken) {
    throw UnimplementedError();
  }
}
