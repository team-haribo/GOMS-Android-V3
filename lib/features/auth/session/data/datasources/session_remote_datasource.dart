import 'package:dio/dio.dart';
import 'package:goms/features/auth/session/data/dto/signin/signin_request_dto.dart';
import 'package:goms/features/auth/session/data/dto/signin/signin_response_dto.dart';

class SessionRemoteDataSource {
  const SessionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SignInResponseDto> signIn(SignInRequestDto requestDto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v3/auth/signin',
      data: requestDto.toJson(),
    );

    return SignInResponseDto.fromJson(response.data ?? const {});
  }

  Future<SignInResponseDto> reissue(String refreshToken) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v3/auth/reissue',
      options: Options(
        headers: {
          'RefreshToken': refreshToken,
        },
      ),
    );

    return SignInResponseDto.fromJson(response.data ?? const {});
  }

  Future<void> signOut(String refreshToken) {
    return _dio.delete<void>(
      '/api/v3/auth/signout',
      options: Options(
        headers: {
          'RefreshToken': refreshToken,
        },
      ),
    );
  }
}
