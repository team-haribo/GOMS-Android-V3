import 'package:goms/features/outing/data/datasources/outing_remote_datasource.dart';
import 'package:goms/features/outing/data/dto/qr/process_outing_by_qr_request_dto.dart';
import 'package:goms/features/outing/data/response/list/current_outing_students_response.dart';
import 'package:goms/features/outing/data/response/qr/process_coming_by_qr_response.dart';
import 'package:goms/features/outing/data/response/qr/process_outing_by_qr_response.dart';
import 'package:goms/features/outing/data/response/search/search_outing_students_response.dart';
import 'package:goms/features/outing/data/response/status/my_outing_status_response.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_coming_qr_result_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_qr_result_entity.dart';
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
  Future<List<OutingStudentEntity>> getCurrentOutingStudents() async {
    final response = await _remoteDataSource.getCurrentOutingStudents();
    return response.toEntity();
  }

  @override
  Future<OutingQrResultEntity> processOutingByQr({
    required String uuid,
    required int exp,
  }) async {
    final response = await _remoteDataSource.processOutingByQr(
      ProcessOutingByQrRequestDto(uuid: uuid, exp: exp),
    );
    return response.toEntity();
  }

  @override
  Future<OutingComingQrResultEntity> processComingByQr({
    required String uuid,
    required int exp,
  }) async {
    final response = await _remoteDataSource.processComingByQr(
      ProcessOutingByQrRequestDto(uuid: uuid, exp: exp),
    );
    return response.toEntity();
  }

  @override
  Future<List<OutingStudentEntity>> searchOutingStudents({
    required String name,
  }) async {
    final response = await _remoteDataSource.searchOutingStudents(name);
    return response.toEntity();
  }

  @override
  Future<OutingQrResultEntity> forceOutStudent({required int memberId}) async {
    final response = await _remoteDataSource.forceOutStudent(memberId);
    return response.toEntity();
  }

  @override
  Future<OutingComingQrResultEntity> forceInStudent({
    required int memberId,
  }) async {
    final response = await _remoteDataSource.forceInStudent(memberId);
    return response.toEntity();
  }
}
