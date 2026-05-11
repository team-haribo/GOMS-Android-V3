import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';
import 'package:goms/features/outing/presentation/models/my_outing_status_model.dart';
import 'package:goms/features/outing/presentation/models/outing_coming_qr_result_model.dart';
import 'package:goms/features/outing/presentation/models/outing_qr_result_model.dart';
import 'package:goms/features/outing/presentation/models/outing_student_model.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/data/repositories/outing_repository.dart';
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

      final students =
          container.read(currentOutingStudentsProvider).requireValue;

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

      final students =
          container.read(currentOutingStudentsProvider).requireValue;

      expect(students.map((e) => e.memberId), [1, 2]);
    });
  });
}

class _FakeOutingRepository implements OutingRepository {
  const _FakeOutingRepository({required this.shouldFailForceIn});

  final bool shouldFailForceIn;

  // ignore: require_trailing_commas
  @override
  Future<OutingComingQrResultModel> forceInStudent({
    required int memberId,
  }) async {
    if (shouldFailForceIn) {
      throw DioException(
        requestOptions:
            RequestOptions(path: '/api/v3/student-council/status/in/$memberId'),
      );
    }

    return OutingComingQrResultModel(
      action: OutingAction.inAction,
      outingId: 1,
      status: OutingStatusType.coming,
      comingAt: DateTime(2026, 4, 13, 12),
      lateCreated: false,
      lateId: 0,
    );
  }

  @override
  Future<List<OutingStudentModel>> getCurrentOutingStudents() async => [
        OutingStudentModel(
          memberId: 1,
          name: '이주언',
          grade: 8,
          department: 'AI',
          outingAt: DateTime(2026, 4, 2, 10, 30),
        ),
        OutingStudentModel(
          memberId: 2,
          name: '김민솔',
          grade: 9,
          department: 'SW',
          outingAt: DateTime(2026, 4, 2, 11, 0),
        ),
      ];

  @override
  Future<OutingQrResultModel> forceOutStudent({required int memberId}) {
    throw UnimplementedError();
  }

  @override
  Future<MyOutingStatusModel> getMyOutingStatus() {
    throw UnimplementedError();
  }

  @override
  Future<OutingComingQrResultModel> processComingByQr({
    required String uuid,
    required int exp,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<OutingQrResultModel> processOutingByQr({
    required String uuid,
    required int exp,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<OutingStudentModel>> searchOutingStudents({
    required String name,
  }) {
    throw UnimplementedError();
  }
}

class _FakeCurrentOutingStudentsNotifier extends CurrentOutingStudentsNotifier {
  @override
  Future<List<OutingStudentModel>> build() async => [
        OutingStudentModel(
          memberId: 1,
          name: '이주언',
          grade: 8,
          department: 'AI',
          outingAt: DateTime(2026, 4, 2, 10, 30),
        ),
        OutingStudentModel(
          memberId: 2,
          name: '김민솔',
          grade: 9,
          department: 'SW',
          outingAt: DateTime(2026, 4, 2, 11, 0),
        ),
      ];
}
