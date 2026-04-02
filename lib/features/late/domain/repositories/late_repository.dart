import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';

abstract class LateRepository {
  Future<List<LateRankStudentEntity>> getLateRankStudents();
}
