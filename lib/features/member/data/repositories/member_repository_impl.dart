import 'package:goms/features/member/data/datasources/member_remote_datasource.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';

class MemberRepositoryImpl implements MemberRepository {
  const MemberRepositoryImpl(this._remoteDataSource);

  final MemberRemoteDataSource _remoteDataSource;

  @override
  Future<List<MemberEntity>> getMembers() async {
    final members = await _remoteDataSource.getMembers();
    return members.map((member) => member.toEntity()).toList();
  }

  @override
  Future<CurrentMemberEntity> getMyRole() async {
    final currentMember = await _remoteDataSource.getMyRole();
    return currentMember.toEntity();
  }

  @override
  Future<List<StudentCouncilStudentEntity>> getStudentCouncilMembers({
    String? query,
  }) async {
    final normalizedQuery = query?.trim() ?? '';
    final response = normalizedQuery.isEmpty
        ? await _remoteDataSource.getStudentCouncilMembers()
        : await _remoteDataSource.searchStudentCouncilMembers(normalizedQuery);

    return response.toEntity();
  }

  @override
  Future<List<StudentCouncilStudentEntity>> getFilteredStudentCouncilMembers({
    required StudentCouncilFilterRequest filter,
  }) async {
    final queryParameters = filter.toQueryParameters();
    final response = queryParameters.isEmpty
        ? await _remoteDataSource.getStudentCouncilMembers()
        : await _remoteDataSource.filterStudentCouncilMembers(queryParameters);

    return response.toEntity();
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
  Future<void> withdrawMember({required String password}) {
    return _remoteDataSource.withdrawMember({'password': password});
  }
}
