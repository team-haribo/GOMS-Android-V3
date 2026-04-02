import 'package:dio/dio.dart';
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

  @GET('/api/v3/outing/search')
  Future<SearchOutingStudentsResponse> searchOutingStudents(
    @Query('name') String name,
  );
}
