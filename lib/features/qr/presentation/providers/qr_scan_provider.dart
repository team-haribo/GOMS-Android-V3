import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/qr/presentation/models/qr_scan_state.dart';

final qrScanProvider =
    NotifierProvider.autoDispose<QrScanNotifier, QrScanState>(
  QrScanNotifier.new,
);

final qrScanProcessingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(qrScanProvider).isProcessing;
});

class QrScanNotifier extends Notifier<QrScanState> {
  @override
  QrScanState build() => const QrScanState.idle();

  Future<void> processScan(String rawValue) async {
    if (state.isProcessing) return;

    state = const QrScanState.processing();

    try {
      final payload = _parsePayload(rawValue);
      final myStatus =
          await ref.read(outingRepositoryProvider).getMyOutingStatus();

      switch (myStatus.status) {
        case OutingStatusType.cannotOuting:
          state = const QrScanState.success(QrScanResultType.cannotGoOut);
          return;
        case OutingStatusType.outing:
          final response =
              await ref.read(outingRepositoryProvider).processComingByQr(
                    uuid: payload.uuid,
                    exp: payload.exp,
                  );
          state = QrScanState.success(
            response.lateCreated
                ? QrScanResultType.lateReturn
                : QrScanResultType.returnSuccess,
          );
          return;
        case OutingStatusType.coming:
          await ref.read(outingRepositoryProvider).processOutingByQr(
                uuid: payload.uuid,
                exp: payload.exp,
              );
          state = const QrScanState.success(QrScanResultType.outingStarted);
          return;
      }
    } on FormatException catch (error) {
      state = QrScanState.failure(error.message);
    } on DioException catch (error) {
      state = QrScanState.failure(
        NetworkException.fromDioException(error).message,
      );
    } on StateError catch (error) {
      state = QrScanState.failure(error.message);
    } catch (_) {
      state = const QrScanState.failure('QR 처리에 실패했어요. 다시 시도해 주세요.');
    }
  }
}

class _QrPayload {
  const _QrPayload({
    required this.uuid,
    required this.exp,
  });

  final String uuid;
  final int exp;
}

_QrPayload _parsePayload(String rawValue) {
  final trimmed = rawValue.trim();
  if (trimmed.isEmpty) {
    throw const FormatException('QR 정보가 비어 있어요.');
  }

  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is Map<String, dynamic>) {
      return _payloadFromMap(decoded);
    }
  } catch (_) {
    // JSON이 아니면 URI 형식으로 재시도한다.
  }

  final uri = Uri.tryParse(trimmed);
  if (uri != null) {
    final query = uri.queryParameters;
    if (query.containsKey('uuid') && query.containsKey('exp')) {
      return _payloadFromMap(query);
    }
  }

  throw const FormatException('올바르지 않은 QR 형식이에요.');
}

_QrPayload _payloadFromMap(Map<dynamic, dynamic> map) {
  final uuid = map['uuid']?.toString().trim() ?? '';
  final expValue = map['exp'];
  final exp = expValue is int ? expValue : int.tryParse(expValue.toString());

  if (uuid.isEmpty || exp == null) {
    throw const FormatException('QR 정보가 올바르지 않아요.');
  }

  return _QrPayload(uuid: uuid, exp: exp);
}
