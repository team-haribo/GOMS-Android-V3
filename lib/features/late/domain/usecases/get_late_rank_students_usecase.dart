import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';
import 'package:goms/features/late/domain/repositories/late_repository.dart';

class GetLateRankStudentsUseCase {
  const GetLateRankStudentsUseCase(this._repository);

  final LateRepository _repository;

  Future<List<LateRankStudentEntity>> call() {
    return _repository.getLateRankStudents();
  }
}
