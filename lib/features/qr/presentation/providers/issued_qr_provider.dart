import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/qr/data/providers/qr_data_providers.dart';
import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';

final issuedQrProvider =
    AsyncNotifierProvider<IssuedQrNotifier, IssuedQrEntity>(
  IssuedQrNotifier.new,
);

class IssuedQrNotifier extends AsyncNotifier<IssuedQrEntity> {
  @override
  Future<IssuedQrEntity> build() async {
    return _issueQr();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_issueQr);
  }

  Future<IssuedQrEntity> _issueQr() async {
    try {
      return await ref.read(qrRepositoryProvider).issueQr();
    } on DioException catch (error) {
      throw IssueQrException(NetworkException.fromDioException(error).message);
    } catch (error) {
      if (error is IssueQrException) {
        rethrow;
      }
      throw const IssueQrException('QR 발급에 실패했어요.');
    }
  }
}

class IssueQrException implements Exception {
  const IssueQrException(this.message);

  final String message;
}
