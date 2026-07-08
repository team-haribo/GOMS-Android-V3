import 'package:dio/dio.dart';
import 'package:goms/features/late/data/response/list/late_rank_students_response.dart';

class LateRemoteDataSource {
  const LateRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LateRankStudentsResponse> getLateRankStudents() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v3/late/rank');
    return LateRankStudentsResponse.fromJson(response.data ?? const {});
  }

  Future<LateRankStudentsResponse> getStudentCouncilLateStudents({
    String? date,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/student-council/late',
      queryParameters: {
        if (date != null && date.isNotEmpty) 'date': date,
      },
    );

    return LateRankStudentsResponse.fromJson(response.data ?? const {});
  }
}
