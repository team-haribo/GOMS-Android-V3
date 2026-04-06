import 'package:goms/features/late/data/datasources/late_remote_datasource.dart';
import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';
import 'package:goms/features/late/domain/repositories/late_repository.dart';
import 'package:intl/intl.dart';

class LateRepositoryImpl implements LateRepository {
  const LateRepositoryImpl(this._remoteDataSource);

  final LateRemoteDataSource _remoteDataSource;

  @override
  Future<List<LateRankStudentEntity>> getLateRankStudents() async {
    final response = await _remoteDataSource.getLateRankStudents();
    return response.toEntity();
  }

  @override
  Future<List<LateRankStudentEntity>> getStudentCouncilLateStudents({
    DateTime? date,
  }) async {
    final response = await _remoteDataSource.getStudentCouncilLateStudents(
      date: date == null ? null : DateFormat('yyyy-MM-dd').format(date),
    );
    return response.toEntity();
  }
}
