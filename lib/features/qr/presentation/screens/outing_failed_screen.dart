import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/features/qr/presentation/routes/qr_route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/qr/presentation/screens/qr_base_screen.dart';

/// 외출에 실패했어요.. 화면
/// QR 처리 실패 시 표시되는 화면.
/// 외출 시작 시각 전 거부처럼 이유가 분명한 실패는 [message]로 이유를 보여준다.
class OutingFailedScreen extends StatelessWidget {
  /// 카메라로 돌아가기 버튼 콜백
  final VoidCallback? onRetryWithCamera;

  /// 부제에 표시할 실패 이유. null이면 기본 문구를 보여준다.
  final String? message;

  const OutingFailedScreen({
    super.key,
    this.onRetryWithCamera,
    this.message,
  });

  static const defaultMessage = '예기치 못한 오류가 발생했어요.\n다시 시도해 주세요!';

  @override
  Widget build(BuildContext context) {
    return QrBaseScreen(
      icon: AppIcons.errorCircle(),
      title: '외출에 실패했어요..',
      subtitle: message ?? defaultMessage,
      buttonText: '카메라로 돌아가기',
      onPressed: onRetryWithCamera ?? () => context.go(QrRoutePath.qr),
    );
  }
}
