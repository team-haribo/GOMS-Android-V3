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
  /// 로그아웃([clear])·로그인([fetch])마다 올라가는 세션 번호.
  /// [refreshProfile]은 요청 시점의 번호와 응답 시점의 번호가 다르면 응답을 버려,
  /// 같은 계정으로 재로그인한 경우에도 이전 세션의 응답이 새 세션을 덮지 않게 한다.
  int _generation = 0;

  @override
  Future<CurrentMemberEntity?> build() async => null;

  Future<CurrentMemberEntity> fetch() async {
    _generation++;
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
  /// 최신 프로필을 반영했으면 true, 실패했거나 반영하지 않았으면 false를 돌려준다.
  Future<bool> refreshProfile() async {
    final currentMember = state.asData?.value;
    if (currentMember == null) {
      return false;
    }
    final generation = _generation;

    try {
      final latestProfile =
          await ref.read(memberRepositoryProvider).getMyProfile();

      // await 동안 로그아웃·재로그인됐다면 이전 세션의 응답이므로 버린다.
      final latestMember = state.asData?.value;
      if (generation != _generation || latestMember == null) {
        return false;
      }

      // await 동안 프로필 사진 변경 등으로 멤버가 갱신됐다면, 요청 시점의 응답으로
      // 그 변경을 되돌리지 않도록 role만 반영한다.
      state = AsyncData(
        identical(latestMember, currentMember)
            ? latestProfile
            : latestMember.copyWith(role: latestProfile.role),
      );
      return true;
    } catch (error, stackTrace) {
      Logger.e(
        'refreshProfile failed: $error',
        tag: 'MEMBER',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  void clear() {
    _generation++;
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
