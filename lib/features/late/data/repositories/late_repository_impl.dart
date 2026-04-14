import 'package:goms/features/late/data/datasources/late_remote_datasource.dart';
import 'package:goms/features/late/data/repositories/late_repository.dart';
import 'package:goms/features/late/ui/models/late_rank_student_model.dart';
import 'package:intl/intl.dart';

class LateRepositoryImpl implements LateRepository {
  const LateRepositoryImpl(this._remoteDataSource);

  final LateRemoteDataSource _remoteDataSource;

  @override
  Future<List<LateRankStudentModel>> getLateRankStudents() async {
    final response = await _remoteDataSource.getLateRankStudents();
    return response.toModel();
  }

  @override
  Future<List<LateRankStudentModel>> getStudentCouncilLateStudents({
    DateTime? date,
  }) async {
    final response = await _remoteDataSource.getStudentCouncilLateStudents(
      date: date == null ? null : DateFormat('yyyy-MM-dd').format(date),
    );
    return response.toModel();
  }
}
