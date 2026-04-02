import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';

final currentOutingStudentsProvider = AsyncNotifierProvider<
    CurrentOutingStudentsNotifier,
    List<OutingStudentEntity>>(CurrentOutingStudentsNotifier.new);

class CurrentOutingStudentsNotifier
    extends AsyncNotifier<List<OutingStudentEntity>> {
  @override
  Future<List<OutingStudentEntity>> build() async {
    return _fetch();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<OutingStudentEntity>> _fetch() async {
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw const CurrentOutingStudentsException('로그인이 필요합니다.');
    }

    try {
      return await ref
          .read(outingRepositoryProvider)
          .getCurrentOutingStudents();
    } on DioException catch (error) {
      throw CurrentOutingStudentsException(
        NetworkException.fromDioException(error).message,
      );
    } catch (error) {
      if (error is CurrentOutingStudentsException) {
        rethrow;
      }
      throw const CurrentOutingStudentsException(
        '현재 외출 중인 학생 목록을 불러오지 못했습니다.',
      );
    }
  }
}

class CurrentOutingStudentsException implements Exception {
  const CurrentOutingStudentsException(this.message);

  final String message;
}
