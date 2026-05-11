import 'package:dio/dio.dart';
import 'package:goms/features/member/data/datasources/member_remote_datasource.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/data/repositories/member_repository.dart';
import 'package:goms/features/member/presentation/models/current_member_model.dart';
import 'package:goms/features/member/presentation/models/member_model.dart';
import 'package:goms/features/member/presentation/models/student_council_student_model.dart';

class MemberRepositoryImpl implements MemberRepository {
  const MemberRepositoryImpl(this._remoteDataSource);

  final MemberRemoteDataSource _remoteDataSource;

  @override
  Future<List<MemberModel>> getMembers() async {
    final members = await _remoteDataSource.getMembers();
    return members.map((member) => member.toModel()).toList();
  }

  @override
  Future<CurrentMemberModel> getMyProfile() async {
    final currentMember = await _remoteDataSource.getMyProfile();
    return currentMember.toModel();
  }

  @override
  Future<List<StudentCouncilStudentModel>> getStudentCouncilMembers({
    String? query,
  }) async {
    final normalizedQuery = query?.trim() ?? '';
    final response = normalizedQuery.isEmpty
        ? await _remoteDataSource.getStudentCouncilMembers()
        : await _remoteDataSource.searchStudentCouncilMembers(normalizedQuery);

    return response.toModel();
  }

  @override
  Future<List<StudentCouncilStudentModel>> getFilteredStudentCouncilMembers({
    required StudentCouncilFilterRequest filter,
  }) async {
    final queryParameters = filter.toQueryParameters();
    final response = queryParameters.isEmpty
        ? await _remoteDataSource.getStudentCouncilMembers()
        : await _remoteDataSource.filterStudentCouncilMembers(queryParameters);

    return response.toModel();
  }

  @override
  Future<void> updateStudentCouncilRole({
    required int memberId,
    required bool isCouncil,
  }) {
    return _remoteDataSource.updateStudentCouncilRole(memberId, {
      'role': isCouncil ? 'ROLE_STUDENT_COUNCIL' : 'ROLE_STUDENT',
    });
  }

  @override
  Future<void> updateStudentCouncilOutingAllowed({
    required int memberId,
    required bool isAllowed,
  }) {
    return _remoteDataSource.updateStudentCouncilOutingAllowed(memberId, {
      'status': isAllowed ? 'COMING' : 'CANNOT_OUTING',
    });
  }

  @override
  Future<String> updateProfileImage({required String imagePath}) async {
    final image = await MultipartFile.fromFile(imagePath);
    final response = await _remoteDataSource.updateProfileImage(image);
    return response.imageUrl;
  }

  @override
  Future<void> withdrawMember({required String password}) {
    return _remoteDataSource.withdrawMember({'password': password});
  }
}
