import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/presentation/qr/scan/response/screens/qr_base_screen.dart';

/// 복귀에 성공했어요! 화면
/// QR 스캔 후 복귀 성공 시 표시되는 화면
class ReturnSuccessScreen extends ConsumerWidget {
  /// 확인 버튼 콜백
  final VoidCallback? onConfirm;

  const ReturnSuccessScreen({
    super.key,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QrBaseScreen(
      icon: AppIcons.successCircle(),
      title: '복귀에 성공했어요!',
      subtitle: '제 때 복귀하셨군요!\n다음 외출제 때 또 만나요!',
      buttonText: '확인',
      onPressed: onConfirm,
    );
  }
}
