import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/member/ui/providers/current_member_provider.dart';

final roleProvider = Provider<RoleEnum>((ref) {
  final currentMemberAsync = ref.watch(currentMemberProvider);

  return currentMemberAsync.when(
    data: (member) => member?.role ?? RoleEnum.user,
    loading: () => RoleEnum.user,
    error: (_, __) => RoleEnum.user,
  );
});
