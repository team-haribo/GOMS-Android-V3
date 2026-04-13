import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
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
