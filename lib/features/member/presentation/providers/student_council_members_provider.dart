import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';

final studentCouncilMemberSearchProvider = StateProvider<String>((ref) => '');

final studentCouncilMembersProvider = AsyncNotifierProvider<
    StudentCouncilMembersNotifier,
    List<StudentCouncilStudentEntity>>(StudentCouncilMembersNotifier.new);

class StudentCouncilMembersNotifier
    extends AsyncNotifier<List<StudentCouncilStudentEntity>> {
  @override
  Future<List<StudentCouncilStudentEntity>> build() async {
    final query = ref.watch(studentCouncilMemberSearchProvider);
    return _fetch(query);
  }

  Future<void> reload() async {
    final query = ref.read(studentCouncilMemberSearchProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(query));
  }

  Future<List<StudentCouncilStudentEntity>> _fetch(String query) async {
    try {
      return await ref.read(memberRepositoryProvider).getStudentCouncilMembers(
            query: query,
          );
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
