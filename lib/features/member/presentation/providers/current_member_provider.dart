import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/utils/logger.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';

final currentMemberProvider =
    AsyncNotifierProvider<CurrentMemberNotifier, CurrentMemberEntity?>(
  CurrentMemberNotifier.new,
);

class CurrentMemberNotifier extends AsyncNotifier<CurrentMemberEntity?> {
  @override
  Future<CurrentMemberEntity?> build() async => null;

  Future<CurrentMemberEntity> fetch() async {
    if (!state.hasValue) {
      state = const AsyncLoading();
    }

    try {
      final currentMember =
          await ref.read(memberRepositoryProvider).getMyProfile();
      state = AsyncData(currentMember);
      return currentMember;
    } on DioException catch (error, stackTrace) {
      state = AsyncError(
        NetworkException.fromDioException(error),
        stackTrace,
      );
      rethrow;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// `/member/profile`을 다시 조회해 현재 멤버(권한 포함)를 최신화한다.
  /// 조회 실패는 무시하고 기존 값을 유지한다(화면이 에러 상태로 바뀌지 않도록).
  Future<void> refreshProfile() async {
    final currentMember = state.asData?.value;
    if (currentMember == null) {
      return;
    }

    try {
      final latestProfile =
          await ref.read(memberRepositoryProvider).getMyProfile();

      // await 동안 상태가 바뀌었을 수 있다(로그아웃으로 clear() 호출 등).
      // 최신 상태를 다시 확인하고, null이거나 다른 멤버로 바뀌었으면 반영하지 않는다.
      final latestMember = state.asData?.value;
      if (latestMember == null ||
          latestMember.memberId != currentMember.memberId) {
        return;
      }

      state = AsyncData(latestProfile);
    } catch (error, stackTrace) {
      Logger.e(
        'refreshProfile failed: $error',
        tag: 'MEMBER',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void clear() {
    state = const AsyncData(null);
  }

  void updateProfileImageUrl(String imageUrl) {
    final currentMember = state.asData?.value;
    if (currentMember == null) {
      return;
    }

    state = AsyncData(currentMember.copyWith(profileImageUrl: imageUrl));
  }
}
