import 'package:dio/dio.dart';

class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;

  factory NetworkException.fromDioException(DioException exception) {
    final data = exception.response?.data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['message'],
        data['error'],
        data['detail'],
      ];

      for (final candidate in candidates) {
        if (candidate is String && candidate.trim().isNotEmpty) {
          return NetworkException(candidate);
        }
      }
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return const NetworkException('요청 시간이 초과되었습니다. 다시 시도해주세요.');
    }

    if (exception.type == DioExceptionType.connectionError) {
      return const NetworkException('네트워크 연결을 확인해주세요.');
    }

    return const NetworkException('요청 처리 중 오류가 발생했습니다.');
  }

  @override
  String toString() => message;
}
