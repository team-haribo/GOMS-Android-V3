import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/qr/scan/response/screens/qr_base_screen.dart';

/// 외출을 시작해 봐요! 화면
/// QR 스캔 후 외출 성공 시 표시되는 화면
class OutingStartScreen extends StatelessWidget {
  /// 확인 버튼 콜백
  final VoidCallback? onConfirm;

  const OutingStartScreen({
    super.key,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? AppColors.sub1Dark : AppColors.sub2;

    return QrBaseScreen(
      icon: AppIcons.comeBackSuccess(),
      title: '외출을 시작해 봐요!',
      subtitle: '지금부터 외출하실 수 있어요.',
      buttonText: '확인',
      onPressed: onConfirm,
      // 복귀 시간 강조 텍스트
      extraContent: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '7시25분',
              style: AppTextStyles.text2.withColor(AppColors.mainColor),
            ),
            TextSpan(
              text: ' 까지 꼭 복귀해 주세요.',
              style: AppTextStyles.text2.withColor(subtitleColor),
            ),
          ],
        ),
      ),
    );
  }
}
