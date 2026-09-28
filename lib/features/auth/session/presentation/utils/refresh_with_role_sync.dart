import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';

/// 당겨서 새로고침에서 화면 데이터와 권한을 함께 갱신한다. (이슈 #146)
///
/// 권한(프로필) 조회에 실패하면 기존 화면은 그대로 두고 스낵바로 알린다.
Future<void> refreshWithRoleSync(
  BuildContext context,
  WidgetRef ref,
  List<Future<void>> reloads,
) async {
  final roleSync = ref.read(authProvider.notifier).syncRole(force: true);
  await Future.wait(reloads);
  final synced = await roleSync;

  if (!synced && context.mounted) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('최신 정보를 불러오지 못했어요. 잠시 후 다시 시도해주세요.'),
      ),
    );
  }
}
