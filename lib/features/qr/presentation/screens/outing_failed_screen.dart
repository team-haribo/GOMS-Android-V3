import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/qr/presentation/screens/qr_base_screen.dart';

/// 외출에 실패했어요.. 화면
/// 예기치 못한 오류 발생 시 표시되는 화면
class OutingFailedScreen extends StatelessWidget {
  /// 카메라로 돌아가기 버튼 콜백
  final VoidCallback? onRetryWithCamera;

  const OutingFailedScreen({
    super.key,
    this.onRetryWithCamera,
  });

  @override
  Widget build(BuildContext context) {
    return QrBaseScreen(
      icon: AppIcons.errorCircle(),
      title: '외출에 실패했어요..',
      subtitle: '예기치 못한 오류가 발생했어요.\n다시 시도해 주세요!',
      buttonText: '카메라로 돌아가기',
      onPressed: onRetryWithCamera ?? () => context.go(RoutePath.qr),
    );
  }
}
