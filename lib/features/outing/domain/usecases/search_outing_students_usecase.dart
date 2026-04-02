import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

class SearchOutingStudentsUseCase {
  const SearchOutingStudentsUseCase(this._repository);

  final OutingRepository _repository;

  Future<List<OutingStudentEntity>> call({required String name}) {
    return _repository.searchOutingStudents(name: name);
  }
}
