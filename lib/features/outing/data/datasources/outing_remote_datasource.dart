import 'package:dio/dio.dart';
import 'package:goms/features/outing/data/dto/qr/process_outing_by_qr_request_dto.dart';
import 'package:goms/features/outing/data/response/list/current_outing_students_response.dart';
import 'package:goms/features/outing/data/response/qr/process_coming_by_qr_response.dart';
import 'package:goms/features/outing/data/response/qr/process_outing_by_qr_response.dart';
import 'package:goms/features/outing/data/response/search/search_outing_students_response.dart';
import 'package:goms/features/outing/data/response/status/my_outing_status_response.dart';
import 'package:retrofit/retrofit.dart';

part 'outing_remote_datasource.g.dart';

@RestApi()
abstract class OutingRemoteDataSource {
  factory OutingRemoteDataSource(Dio dio, {String? baseUrl}) =
      _OutingRemoteDataSource;

  @GET('/api/v3/outing/status')
  Future<MyOutingStatusResponse> getMyOutingStatus();

  @GET('/api/v3/outing/list')
  Future<CurrentOutingStudentsResponse> getCurrentOutingStudents();

  @POST('/api/v3/outing/out')
  Future<ProcessOutingByQrResponse> processOutingByQr(
    @Body() ProcessOutingByQrRequestDto requestDto,
  );

  @POST('/api/v3/outing/in')
  Future<ProcessComingByQrResponse> processComingByQr(
    @Body() ProcessOutingByQrRequestDto requestDto,
  );

  @GET('/api/v3/outing/search')
  Future<SearchOutingStudentsResponse> searchOutingStudents(
    @Query('name') String name,
  );
}
