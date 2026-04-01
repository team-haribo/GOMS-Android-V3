import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/config/dark_theme.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/qr/shared/presentation/screens/qr_base_screen.dart';

void main() async {
  runApp(
    MaterialApp(
      home: const OutingStartScreen(),
      themeMode: ThemeMode.dark,
      theme: DarkTheme.theme,
    ),
  );
}

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
    return QrBaseScreen(
      icon: AppIcons.outingSuccess(
        width: 150,
        height: 150,
      ),
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
              style: AppTextStyles.text2.withColor(context.sub1Color),
            ),
          ],
        ),
      ),
    );
  }
}
