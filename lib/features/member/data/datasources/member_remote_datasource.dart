import 'package:dio/dio.dart';
import 'package:goms/features/member/data/models/member_dto.dart';

class MemberRemoteDataSource {
  const MemberRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<MemberDto>> getMembers() async {
    final response = await _dio.get<List<dynamic>>('/members');
    final data = response.data;

    if (data == null) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((json) => MemberDto.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> withdrawMember(String password) {
    return _dio.delete<void>(
      '/api/v3/member/withdraw',
      data: {'password': password},
    );
  }
}
