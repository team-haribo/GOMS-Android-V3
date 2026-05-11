import 'package:goms/features/outing/data/datasources/outing_remote_datasource.dart';
import 'package:goms/features/outing/data/dto/qr/process_outing_by_qr_request_dto.dart';
import 'package:goms/features/outing/data/response/list/current_outing_students_response.dart';
import 'package:goms/features/outing/data/response/qr/process_coming_by_qr_response.dart';
import 'package:goms/features/outing/data/response/qr/process_outing_by_qr_response.dart';
import 'package:goms/features/outing/data/response/search/search_outing_students_response.dart';
import 'package:goms/features/outing/data/response/status/my_outing_status_response.dart';
import 'package:goms/features/outing/presentation/models/my_outing_status_model.dart';
import 'package:goms/features/outing/presentation/models/outing_coming_qr_result_model.dart';
import 'package:goms/features/outing/presentation/models/outing_qr_result_model.dart';
import 'package:goms/features/outing/presentation/models/outing_student_model.dart';
import 'package:goms/features/outing/data/repositories/outing_repository.dart';

class OutingRepositoryImpl implements OutingRepository {
  const OutingRepositoryImpl({
    required OutingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final OutingRemoteDataSource _remoteDataSource;

  @override
  Future<MyOutingStatusModel> getMyOutingStatus() async {
    final response = await _remoteDataSource.getMyOutingStatus();
    return response.toModel();
  }

  @override
  Future<List<OutingStudentModel>> getCurrentOutingStudents() async {
    final response = await _remoteDataSource.getCurrentOutingStudents();
    return response.toModel();
  }

  @override
  Future<OutingQrResultModel> processOutingByQr({
    required String uuid,
    required int exp,
  }) async {
    final response = await _remoteDataSource.processOutingByQr(
      ProcessOutingByQrRequestDto(uuid: uuid, exp: exp),
    );
    return response.toModel();
  }

  @override
  Future<OutingComingQrResultModel> processComingByQr({
    required String uuid,
    required int exp,
  }) async {
    final response = await _remoteDataSource.processComingByQr(
      ProcessOutingByQrRequestDto(uuid: uuid, exp: exp),
    );
    return response.toModel();
  }

  @override
  Future<List<OutingStudentModel>> searchOutingStudents({
    required String name,
  }) async {
    final response = await _remoteDataSource.searchOutingStudents(name);
    return response.toModel();
  }

  @override
  Future<OutingQrResultModel> forceOutStudent({required int memberId}) async {
    final response = await _remoteDataSource.forceOutStudent(memberId);
    return response.toModel();
  }

  @override
  Future<OutingComingQrResultModel> forceInStudent({
    required int memberId,
  }) async {
    final response = await _remoteDataSource.forceInStudent(memberId);
    return response.toModel();
  }
}
