import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';

abstract class OutingRepository {
  Future<MyOutingStatusEntity> getMyOutingStatus();

  Future<List<OutingStudentEntity>> searchOutingStudents({
    required String name,
  });
}
