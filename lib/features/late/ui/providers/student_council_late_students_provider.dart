import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/late/data/providers/late_data_providers.dart';
import 'package:goms/features/late/ui/models/late_rank_student_model.dart';

final studentCouncilLateDateProvider = StateProvider<DateTime?>((ref) => null);

final studentCouncilLateStudentsProvider = AsyncNotifierProvider<
    StudentCouncilLateStudentsNotifier,
    List<LateRankStudentModel>>(StudentCouncilLateStudentsNotifier.new);

class StudentCouncilLateStudentsNotifier
    extends AsyncNotifier<List<LateRankStudentModel>> {
  @override
  Future<List<LateRankStudentModel>> build() async {
    final date = ref.watch(studentCouncilLateDateProvider);
    return _fetch(date);
  }

  Future<void> reload() async {
    final date = ref.read(studentCouncilLateDateProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(date));
  }

  Future<List<LateRankStudentModel>> _fetch(DateTime? date) async {
    try {
      return await ref
          .read(lateRepositoryProvider)
          .getStudentCouncilLateStudents(date: date);
    } on DioException catch (error) {
      throw StudentCouncilLateStudentsException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const StudentCouncilLateStudentsException(
        '지각자 명단을 불러오지 못했습니다.',
      );
    }
  }
}

class StudentCouncilLateStudentsException implements Exception {
  const StudentCouncilLateStudentsException(this.message);

  final String message;
}
