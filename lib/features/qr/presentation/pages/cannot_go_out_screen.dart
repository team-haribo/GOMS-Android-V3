import 'package:flutter/material.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/features/qr/presentation/pages/qr_base_screen.dart';

/// 외출하실 수 없어요 화면
/// 외출 금지 상태일 때 표시되는 화면
class CannotGoOutScreen extends StatelessWidget {
  /// 홈으로 돌아가기 버튼 콜백
  final VoidCallback? onGoHome;

  const CannotGoOutScreen({
    super.key,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return QrBaseScreen(
      icon: AppIcons.bannedCircle(),
      title: '외출하실 수 없어요',
      subtitle: '외출 금지 상태에서는 외출이 불가능해요.\n다음 외출제를 이용해 주세요.',
      buttonText: '홈으로 돌아가기',
      onPressed: onGoHome,
    );
  }
}




