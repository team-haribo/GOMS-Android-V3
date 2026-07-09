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

  /// 서버 DB 기준 최신 권한(role)을 조회해 현재 멤버에 덮어쓴다.
  /// 권한 조회 실패는 무시하고 기존 프로필 role을 유지한다(best-effort 보정).
  Future<void> refreshRole() async {
    final currentMember = state.asData?.value;
    if (currentMember == null) {
      return;
    }

    try {
      final role = await ref.read(memberRepositoryProvider).getMyRole();
      if (role != currentMember.role) {
        state = AsyncData(currentMember.copyWith(role: role));
      }
    } catch (error, stackTrace) {
      // 권한 보정 실패는 세션을 막지 않고 프로필 role을 그대로 사용한다.
      // 다만 원인 파악을 위해 로그는 남긴다.
      Logger.e(
        'refreshRole failed: $error',
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
