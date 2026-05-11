import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';

final studentCouncilMemberSearchProvider = StateProvider<String>((ref) => '');
final studentCouncilMemberFilterProvider =
    StateProvider<StudentCouncilFilterRequest>(
  (ref) => const StudentCouncilFilterRequest(),
);

final studentCouncilMembersProvider = AsyncNotifierProvider<
    StudentCouncilMembersNotifier,
    List<StudentCouncilStudentEntity>>(StudentCouncilMembersNotifier.new);

class StudentCouncilMembersNotifier
    extends AsyncNotifier<List<StudentCouncilStudentEntity>> {
  @override
  Future<List<StudentCouncilStudentEntity>> build() async {
    final query = ref.watch(studentCouncilMemberSearchProvider);
    final filter = ref.watch(studentCouncilMemberFilterProvider);
    return _fetch(query: query, filter: filter);
  }

  Future<void> reload() async {
    final query = ref.read(studentCouncilMemberSearchProvider);
    final filter = ref.read(studentCouncilMemberFilterProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(query: query, filter: filter));
  }

  void updateFilter(StudentCouncilFilterRequest filter) {
    ref.read(studentCouncilMemberFilterProvider.notifier).state = filter;
  }

  void clearFilter() {
    ref.read(studentCouncilMemberFilterProvider.notifier).state =
        const StudentCouncilFilterRequest();
  }

  void updateMemberStatus({
    required int memberId,
    required String status,
  }) {
    final currentState = state;
    if (currentState is! AsyncData<List<StudentCouncilStudentEntity>>) return;

    state = AsyncData(
      currentState.value
          .map(
            (member) => member.memberId == memberId
                ? member.copyWith(status: status)
                : member,
          )
          .toList(),
    );
  }

  void updateMemberRole({
    required int memberId,
    required StudentRole studentRole,
  }) {
    final currentState = state;
    if (currentState is! AsyncData<List<StudentCouncilStudentEntity>>) return;

    state = AsyncData(
      currentState.value
          .map(
            (member) => member.memberId == memberId
                ? member.copyWith(studentRole: studentRole)
                : member,
          )
          .toList(),
    );
  }

  Future<List<StudentCouncilStudentEntity>> _fetch({
    required String query,
    required StudentCouncilFilterRequest filter,
  }) async {
    try {
      final normalizedQuery = query.trim();
      final mergedFilter = StudentCouncilFilterRequest(
        name: normalizedQuery.isEmpty ? filter.name : normalizedQuery,
        grade: filter.grade,
        department: filter.department,
        gender: filter.gender,
        status: filter.status,
        role: filter.role,
      );

      if (mergedFilter.isEmpty) {
        return await ref
            .read(memberRepositoryProvider)
            .getStudentCouncilMembers(
              query: normalizedQuery,
            );
      }

      return await ref
          .read(memberRepositoryProvider)
          .getFilteredStudentCouncilMembers(filter: mergedFilter);
    } on DioException catch (error) {
      throw StudentCouncilMembersException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const StudentCouncilMembersException(
        '학생 목록을 불러오지 못했습니다.',
      );
    }
  }
}

class StudentCouncilMembersException implements Exception {
  const StudentCouncilMembersException(this.message);

  final String message;
}
