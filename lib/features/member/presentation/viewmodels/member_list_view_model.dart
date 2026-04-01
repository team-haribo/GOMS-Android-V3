import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/presentation/models/member_list_state.dart';

final memberListViewModelProvider =
    NotifierProvider<MemberListViewModel, MemberListState>(
  MemberListViewModel.new,
);

class MemberListViewModel extends Notifier<MemberListState> {
  @override
  MemberListState build() {
    Future<void>.microtask(fetchMembers);
    return const MemberListState.loading();
  }

  Future<void> fetchMembers() async {
    state = const MemberListState.loading();

    try {
      final members = await ref.read(getMembersUseCaseProvider).call();
      state = MemberListState.success(members);
    } on DioException catch (error) {
      state = MemberListState.error(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      state = const MemberListState.error('멤버 정보를 불러오지 못했습니다.');
    }
  }
}
