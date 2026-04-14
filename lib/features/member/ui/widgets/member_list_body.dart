import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/member/ui/providers/member_list_provider.dart';
import 'package:goms/features/member/ui/widgets/member_error_view.dart';
import 'package:goms/features/member/ui/widgets/member_list_section.dart';

class MemberListBody extends ConsumerWidget {
  const MemberListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memberListProvider);

    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (members) => MemberListSection(members: members),
      error: (error, _) => MemberErrorView(
        message: _toErrorMessage(error),
        onRetry: () {
          ref.read(memberListProvider.notifier).reload();
        },
      ),
    );
  }

  String _toErrorMessage(Object error) {
    if (error is MemberListException) {
      return error.message;
    }

    return '오류가 발생했습니다.';
  }
}
