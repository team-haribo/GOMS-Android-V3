import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/outing/data/mappers/outing_error_type_mapper.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_qr_result_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';
import 'package:goms/features/qr/presentation/models/qr_scan_state.dart';
import 'package:goms/features/qr/presentation/providers/qr_scan_provider.dart';

void main() {
  group('QrScanNotifier', () {
    test('cannot outing 상태면 API 호출 없이 차단 결과를 반환한다', () async {
      final repository = _FakeOutingRepository(
        myStatus: const MyOutingStatusEntity(
          memberId: 1,
          status: OutingStatusType.cannotOuting,
          name: '이주언',
          grade: 8,
          department: 'AI',
          lateCount: 0,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          outingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(qrScanProvider.notifier).processScan(
            jsonEncode({'uuid': 'test-uuid', 'exp': 1234567890}),
          );

      expect(
        container.read(qrScanProvider).resultType,
        QrScanResultType.cannotGoOut,
      );
      expect(repository.processOutingCallCount, 0);
      expect(repository.processComingCallCount, 0);
    });

    test('COMING 상태면 외출 API를 호출한다', () async {
      final repository = _FakeOutingRepository(
        myStatus: const MyOutingStatusEntity(
          memberId: 1,
          status: OutingStatusType.coming,
          name: '이주언',
          grade: 8,
          department: 'AI',
          lateCount: 0,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          outingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(qrScanProvider.notifier).processScan(
            jsonEncode({'uuid': 'outing-uuid', 'exp': 987654321}),
          );

      expect(
        container.read(qrScanProvider).resultType,
        QrScanResultType.outingStarted,
      );
      expect(repository.processOutingCallCount, 1);
      expect(repository.lastUuid, 'outing-uuid');
      expect(repository.lastExp, 987654321);
    });

    test('OUTING 상태면 복귀 API를 호출하고 지각 여부를 반영한다', () async {
      final repository = _FakeOutingRepository(
        myStatus: const MyOutingStatusEntity(
          memberId: 1,
          status: OutingStatusType.outing,
          name: '이주언',
          grade: 8,
          department: 'AI',
          lateCount: 0,
        ),
        comingResult: OutingComingQrResultEntity(
          action: OutingAction.inAction,
          outingId: 3,
          status: OutingStatusType.coming,
          comingAt: _fixedDateTime,
          lateCreated: true,
          lateId: 9,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          outingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(qrScanProvider.notifier).processScan(
            'https://goms.app/qr?uuid=coming-uuid&exp=111111',
          );

      expect(
        container.read(qrScanProvider).resultType,
        QrScanResultType.lateReturn,
      );
      expect(repository.processComingCallCount, 1);
      expect(repository.lastUuid, 'coming-uuid');
      expect(repository.lastExp, 111111);
    });

    test('잘못된 QR 형식이면 실패 상태가 된다', () async {
      final repository = _FakeOutingRepository(
        myStatus: const MyOutingStatusEntity(
          memberId: 1,
          status: OutingStatusType.coming,
          name: '이주언',
          grade: 8,
          department: 'AI',
          lateCount: 0,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          outingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(qrScanProvider.notifier).processScan('invalid-qr');

      expect(container.read(qrScanProvider).status, QrScanStatus.failure);
      expect(container.read(qrScanProvider).errorMessage, isNotNull);
      expect(container.read(qrScanProvider).failureScreenMessage, isNull);
    });

    test('외출 시작 시각 전 403이면 실패 화면에 시간 제한 문구를 전달한다', () async {
      final repository = _FakeOutingRepository(
        myStatus: _comingStatus,
        outingError:
            _dioError(403, OutingErrorTypeMapper.outingTimeNotAllowedMessage),
      );
      final container = _containerWith(repository);

      await container.read(qrScanProvider.notifier).processScan(_validQr);

      final state = container.read(qrScanProvider);
      expect(state.status, QrScanStatus.failure);
      expect(state.failureScreenMessage, '외출 가능 시간이 아니에요.');
    });

    test('같은 403이어도 시간 제한이 아니면 실패 화면 메시지를 전달하지 않는다', () async {
      final repository = _FakeOutingRepository(
        myStatus: _comingStatus,
        outingError: _dioError(403, '외출 가능한 학년이 아닙니다.'),
      );
      final container = _containerWith(repository);

      await container.read(qrScanProvider.notifier).processScan(_validQr);

      final state = container.read(qrScanProvider);
      expect(state.status, QrScanStatus.failure);
      expect(state.failureScreenMessage, isNull);
    });

    test('시간 제한 외 서버 오류는 실패 화면 메시지를 전달하지 않는다', () async {
      final repository = _FakeOutingRepository(
        myStatus: _comingStatus,
        outingError: _dioError(400, 'QR 코드가 만료되었습니다.'),
      );
      final container = _containerWith(repository);

      await container.read(qrScanProvider.notifier).processScan(_validQr);

      final state = container.read(qrScanProvider);
      expect(state.status, QrScanStatus.failure);
      expect(state.failureScreenMessage, isNull);
    });
  });
}

const _comingStatus = MyOutingStatusEntity(
  memberId: 1,
  status: OutingStatusType.coming,
  name: '이주언',
  grade: 8,
  department: 'AI',
  lateCount: 0,
);

final _validQr = jsonEncode({'uuid': 'outing-uuid', 'exp': 987654321});

ProviderContainer _containerWith(OutingRepository repository) {
  final container = ProviderContainer(
    overrides: [
      outingRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

DioException _dioError(int statusCode, String message) {
  final requestOptions = RequestOptions(path: '/api/v3/outing/out');
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: {'status': statusCode, 'message': message},
    ),
  );
}

final _fixedDateTime = DateTime(2026, 4, 2, 18, 0);

class _FakeOutingRepository implements OutingRepository {
  _FakeOutingRepository({
    required this.myStatus,
    OutingQrResultEntity? outingResult,
    OutingComingQrResultEntity? comingResult,
    this.outingError,
  })  : outingResult = outingResult ??
            OutingQrResultEntity(
              action: OutingAction.out,
              outingId: 1,
              status: OutingStatusType.outing,
              outingAt: _fixedDateTime,
            ),
        comingResult = comingResult ??
            OutingComingQrResultEntity(
              action: OutingAction.inAction,
              outingId: 2,
              status: OutingStatusType.coming,
              comingAt: _fixedDateTime,
              lateCreated: false,
              lateId: 0,
            );

  final MyOutingStatusEntity myStatus;
  final OutingQrResultEntity outingResult;
  final OutingComingQrResultEntity comingResult;
  final DioException? outingError;

  int processOutingCallCount = 0;
  int processComingCallCount = 0;
  String? lastUuid;
  int? lastExp;

  @override
  Future<List<OutingStudentEntity>> getCurrentOutingStudents() async => [];

  @override
  Future<MyOutingStatusEntity> getMyOutingStatus() async => myStatus;

  @override
  Future<OutingComingQrResultEntity> processComingByQr({
    required String uuid,
    required int exp,
  }) async {
    processComingCallCount++;
    lastUuid = uuid;
    lastExp = exp;
    return comingResult;
  }

  @override
  Future<OutingQrResultEntity> processOutingByQr({
    required String uuid,
    required int exp,
  }) async {
    processOutingCallCount++;
    lastUuid = uuid;
    lastExp = exp;
    final error = outingError;
    if (error != null) throw error;
    return outingResult;
  }

  @override
  Future<List<OutingStudentEntity>> searchOutingStudents({
    required String name,
  }) async =>
      [];

  @override
  Future<OutingComingQrResultEntity> forceInStudent({
    required int memberId,
  }) async =>
      comingResult;

  @override
  Future<OutingQrResultEntity> forceOutStudent({
    required int memberId,
  }) async =>
      outingResult;
}
