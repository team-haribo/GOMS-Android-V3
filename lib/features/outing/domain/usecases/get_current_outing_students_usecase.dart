import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

class GetCurrentOutingStudentsUseCase {
  const GetCurrentOutingStudentsUseCase(this._repository);

  final OutingRepository _repository;

  Future<List<OutingStudentEntity>> call() {
    return _repository.getCurrentOutingStudents();
  }
}
