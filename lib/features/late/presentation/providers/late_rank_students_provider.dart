import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/late/data/providers/late_data_providers.dart';
import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';

final lateRankStudentsProvider = AsyncNotifierProvider<LateRankStudentsNotifier,
    List<LateRankStudentEntity>>(LateRankStudentsNotifier.new);

class LateRankStudentsNotifier
    extends AsyncNotifier<List<LateRankStudentEntity>> {
  @override
  Future<List<LateRankStudentEntity>> build() async {
    return _fetch();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<LateRankStudentEntity>> _fetch() async {
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw const LateRankStudentsException('로그인이 필요합니다.');
    }

    try {
      return await ref.read(getLateRankStudentsUseCaseProvider).call();
    } on DioException catch (error) {
      throw LateRankStudentsException(
        NetworkException.fromDioException(error).message,
      );
    } catch (error) {
      if (error is LateRankStudentsException) {
        rethrow;
      }
      throw const LateRankStudentsException('지각 랭킹을 불러오지 못했습니다.');
    }
  }
}

class LateRankStudentsException implements Exception {
  const LateRankStudentsException(this.message);

  final String message;
}
