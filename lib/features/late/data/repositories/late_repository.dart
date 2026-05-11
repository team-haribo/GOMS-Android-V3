import 'package:goms/features/late/presentation/models/late_rank_student_model.dart';

abstract class LateRepository {
  Future<List<LateRankStudentModel>> getLateRankStudents();

  Future<List<LateRankStudentModel>> getStudentCouncilLateStudents({
    DateTime? date,
  });
}
