import 'package:flutter/material.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/presentation/qr/scan/response/screens/qr_base_screen.dart';

/// 복귀에 성공했어요! 화면
/// QR 스캔 후 복귀 성공 시 표시되는 화면
class ReturnSuccessScreen extends StatelessWidget {
  /// 확인 버튼 콜백
  final VoidCallback? onConfirm;

  const ReturnSuccessScreen({
    super.key,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return QrBaseScreen(
      icon: AppIcons.comeBackSuccessCircle(width: 150, height: 150),
      title: '복귀에 성공했어요!',
      subtitle: '제 때 복귀하셨군요!\n다음 외출제 때 또 만나요!',
      buttonText: '확인',
      onPressed: onConfirm,
    );
  }
}
