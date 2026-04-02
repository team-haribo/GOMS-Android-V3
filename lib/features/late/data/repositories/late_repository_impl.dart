import 'package:goms/features/late/data/datasources/late_remote_datasource.dart';
import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';
import 'package:goms/features/late/domain/repositories/late_repository.dart';

class LateRepositoryImpl implements LateRepository {
  const LateRepositoryImpl(this._remoteDataSource);

  final LateRemoteDataSource _remoteDataSource;

  @override
  Future<List<LateRankStudentEntity>> getLateRankStudents() async {
    final response = await _remoteDataSource.getLateRankStudents();
    return response.toEntity();
  }
}
