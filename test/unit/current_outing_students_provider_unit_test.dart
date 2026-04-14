import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_coming_qr_result_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_qr_result_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';
import 'package:goms/features/outing/presentation/providers/current_outing_students_provider.dart';

void main() {
  group('CurrentOutingStudentsNotifier', () {
    test('forceInStudent removes student optimistically on success', () async {
      final container = ProviderContainer(
        overrides: [
          outingRepositoryProvider.overrideWithValue(
            const _FakeOutingRepository(shouldFailForceIn: false),
          ),
          currentOutingStudentsProvider.overrideWith(
            _FakeCurrentOutingStudentsNotifier.new,
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(currentOutingStudentsProvider.future);

      await container
          .read(currentOutingStudentsProvider.notifier)
          .forceInStudent(memberId: 1);

      final students = container.read(currentOutingStudentsProvider).requireValue;

      expect(students.map((e) => e.memberId), [2]);
    });

    test('forceInStudent restores student when request fails', () async {
      final container = ProviderContainer(
        overrides: [
          outingRepositoryProvider.overrideWithValue(
            const _FakeOutingRepository(shouldFailForceIn: true),
          ),
          currentOutingStudentsProvider.overrideWith(
            _FakeCurrentOutingStudentsNotifier.new,
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(currentOutingStudentsProvider.future);

      try {
        await container
            .read(currentOutingStudentsProvider.notifier)
            .forceInStudent(memberId: 1);
        fail('CurrentOutingStudentsException was not thrown');
      } catch (error) {
        expect(error, isA<CurrentOutingStudentsException>());
      }

      final students = container.read(currentOutingStudentsProvider).requireValue;

      expect(students.map((e) => e.memberId), [1, 2]);
    });
  });
}

class _FakeOutingRepository implements OutingRepository {
  const _FakeOutingRepository({required this.shouldFailForceIn});

  final bool shouldFailForceIn;

  @override
  Future<OutingComingQrResultEntity> forceInStudent({required int memberId}) async {
    if (shouldFailForceIn) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v3/student-council/status/in/$memberId'),
      );
    }

    return OutingComingQrResultEntity(
      action: OutingAction.inAction,
      outingId: 1,
      status: OutingStatusType.coming,
      comingAt: DateTime(2026, 4, 13, 12),
      lateCreated: false,
      lateId: 0,
    );
  }

  @override
  Future<List<OutingStudentEntity>> getCurrentOutingStudents() async => [
        OutingStudentEntity(
          memberId: 1,
          name: '이주언',
          grade: 8,
          department: 'AI',
          outingAt: DateTime(2026, 4, 2, 10, 30),
        ),
        OutingStudentEntity(
          memberId: 2,
          name: '김민솔',
          grade: 9,
          department: 'SW',
          outingAt: DateTime(2026, 4, 2, 11, 0),
        ),
      ];

  @override
  Future<OutingQrResultEntity> forceOutStudent({required int memberId}) {
    throw UnimplementedError();
  }

  @override
  Future<MyOutingStatusEntity> getMyOutingStatus() {
    throw UnimplementedError();
  }

  @override
  Future<OutingComingQrResultEntity> processComingByQr({
    required String uuid,
    required int exp,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<OutingQrResultEntity> processOutingByQr({
    required String uuid,
    required int exp,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<OutingStudentEntity>> searchOutingStudents({
    required String name,
  }) {
    throw UnimplementedError();
  }
}

class _FakeCurrentOutingStudentsNotifier extends CurrentOutingStudentsNotifier {
  @override
  Future<List<OutingStudentEntity>> build() async => [
        OutingStudentEntity(
          memberId: 1,
          name: '이주언',
          grade: 8,
          department: 'AI',
          outingAt: DateTime(2026, 4, 2, 10, 30),
        ),
        OutingStudentEntity(
          memberId: 2,
          name: '김민솔',
          grade: 9,
          department: 'SW',
          outingAt: DateTime(2026, 4, 2, 11, 0),
        ),
      ];
}
