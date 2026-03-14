import 'package:flutter/material.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/features/qr/presentation/pages/qr_base_screen.dart';

/// 지각하셨네요.. 화면
/// 복귀 시간을 초과했을 때 표시되는 화면 (1주간 외출 금지)
class LateScreen extends StatelessWidget {
  /// 확인 버튼 콜백
  final VoidCallback? onConfirm;

  const LateScreen({
    super.key,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return QrBaseScreen(
      icon: AppIcons.bannedCircle(),
      title: '지각하셨네요..',
      subtitle: '앞으로 1주간 외출을 하실 수 없어요.\n다음 외출제 때 또 만나요!',
      buttonText: '확인',
      onPressed: onConfirm,
    );
  }
}
