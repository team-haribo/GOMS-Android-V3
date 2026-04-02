import 'package:goms/features/outing/data/datasources/outing_remote_datasource.dart';
import 'package:goms/features/outing/data/response/search/search_outing_students_response.dart';
import 'package:goms/features/outing/data/response/status/my_outing_status_response.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

class OutingRepositoryImpl implements OutingRepository {
  const OutingRepositoryImpl({
    required OutingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final OutingRemoteDataSource _remoteDataSource;

  @override
  Future<MyOutingStatusEntity> getMyOutingStatus() async {
    final response = await _remoteDataSource.getMyOutingStatus();
    return response.toEntity();
  }

  @override
  Future<List<OutingStudentEntity>> searchOutingStudents({
    required String name,
  }) async {
    final response = await _remoteDataSource.searchOutingStudents(name);
    return response.toEntity();
  }
}
