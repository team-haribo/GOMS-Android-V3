import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/presentation/routes/outing_route_path.dart';

/// 관리자(학생회) 전용 화면을 감싸, 권한이 학생으로 바뀌면 홈으로 내보낸다. (이슈 #150)
///
/// [roleProvider]는 로딩·에러·로그아웃 상태도 학생으로 취급하므로, 여기서는
/// [currentMemberProvider]에 멤버가 실제로 있고 그 권한이 관리자가 아닐 때만 반응한다.
/// 로그아웃(멤버 null)은 세션 흐름이 화면 이동을 맡는다.
class AdminRouteGuard extends ConsumerStatefulWidget {
  const AdminRouteGuard({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AdminRouteGuard> createState() => _AdminRouteGuardState();
}

class _AdminRouteGuardState extends ConsumerState<AdminRouteGuard> {
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    // 권한이 이미 회수된 상태로 진입한 경우(오래된 버튼 탭 등)도 막는다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _leaveIfRevoked(ref.read(currentMemberProvider).asData?.value);
    });
  }

  void _leaveIfRevoked(CurrentMemberEntity? member) {
    if (_leaving || member == null || member.role == RoleEnum.admin) {
      return;
    }
    _leaving = true;

    final messenger = ScaffoldMessenger.maybeOf(context);
    context.go(OutingRoutePath.home);
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('학생회 권한이 없어 홈으로 이동했어요.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<CurrentMemberEntity?>>(
      currentMemberProvider,
      (_, next) => _leaveIfRevoked(next.asData?.value),
    );
    return widget.child;
  }
}
