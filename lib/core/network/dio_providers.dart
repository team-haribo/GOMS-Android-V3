import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/auth_interceptor.dart';
import 'package:goms/core/utils/logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['GOMS_API_BASE_URL']?.trim() ?? '';
  if (baseUrl.isEmpty) {
    throw const DioClientException('GOMS_API_BASE_URL 환경변수가 설정되지 않았습니다.');
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(AuthInterceptor());

  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.d(
            '[REQ] ${options.method} ${options.baseUrl}${options.path}\n'
            'headers=${options.headers}\n'
            'query=${options.queryParameters}\n'
            'body=${options.data}',
            tag: 'DIO',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.d(
            '[RES] ${response.statusCode} ${response.requestOptions.method} '
            '${response.requestOptions.baseUrl}${response.requestOptions.path}\n'
            'body=${response.data}',
            tag: 'DIO',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          Logger.e(
            '[ERR] ${error.response?.statusCode} '
            '${error.requestOptions.method} '
            '${error.requestOptions.baseUrl}${error.requestOptions.path}\n'
            'body=${error.requestOptions.data}\n'
            'response=${error.response?.data}',
            tag: 'DIO',
            error: error,
            stackTrace: error.stackTrace,
          );
          handler.next(error);
        },
      ),
    );
  }

  return dio;
});

class DioClientException implements Exception {
  const DioClientException(this.message);

  final String message;

  @override
  String toString() => message;
}
