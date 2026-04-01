import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/member/presentation/models/member_list_state.dart';
import 'package:goms/features/member/presentation/viewmodels/member_list_view_model.dart';
import 'package:goms/features/member/presentation/widgets/member_error_view.dart';
import 'package:goms/features/member/presentation/widgets/member_list_section.dart';

class MemberListBody extends ConsumerWidget {
  const MemberListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memberListViewModelProvider);

    return switch (state.status) {
      MemberListStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
      MemberListStatus.success => MemberListSection(members: state.members),
      MemberListStatus.error => MemberErrorView(
          message: state.errorMessage ?? '오류가 발생했습니다.',
          onRetry: () {
            ref.read(memberListViewModelProvider.notifier).fetchMembers();
          },
        ),
    };
  }
}
