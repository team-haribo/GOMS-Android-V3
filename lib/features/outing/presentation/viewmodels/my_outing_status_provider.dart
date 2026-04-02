import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';

final myOutingStatusProvider =
    AsyncNotifierProvider<MyOutingStatusNotifier, MyOutingStatusEntity>(
  MyOutingStatusNotifier.new,
);

class MyOutingStatusNotifier extends AsyncNotifier<MyOutingStatusEntity> {
  @override
  Future<MyOutingStatusEntity> build() async {
    return _fetch();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<MyOutingStatusEntity> _fetch() async {
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw const MyOutingStatusException('로그인이 필요합니다.');
    }

    try {
      return await ref.read(getMyOutingStatusUseCaseProvider).call();
    } on DioException catch (error) {
      throw MyOutingStatusException(
        NetworkException.fromDioException(error).message,
      );
    } catch (error) {
      if (error is MyOutingStatusException) {
        rethrow;
      }
      throw const MyOutingStatusException('외출 상태를 불러오지 못했습니다.');
    }
  }
}

class MyOutingStatusException implements Exception {
  const MyOutingStatusException(this.message);

  final String message;
}
