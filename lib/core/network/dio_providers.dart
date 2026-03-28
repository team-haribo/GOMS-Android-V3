import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['GOMS_API_BASE_URL']?.trim() ?? '';
  if (baseUrl.isEmpty) {
    throw const DioClientException('GOMS_API_BASE_URL 환경변수가 설정되지 않았습니다.');
  }

  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );
});

class DioClientException implements Exception {
  const DioClientException(this.message);

  final String message;

  @override
  String toString() => message;
}
