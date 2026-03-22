import 'package:flutter/material.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/buttons/confirm_button.dart';

/// QR 응답 화면 공통 베이스
///
/// 아이콘 / 제목 / 부제목 / 버튼 구조가 동일한 5개 화면에서 공유한다.
/// [extraContent]를 통해 부제목 아래에 추가 위젯(예: 복귀 시간 RichText)을 삽입할 수 있다.
class QrBaseScreen extends StatelessWidget {
  /// 상단 아이콘 위젯
  final Widget icon;

  /// 제목 텍스트
  final String title;

  /// 부제목 텍스트
  final String subtitle;

  /// 버튼 텍스트
  final String buttonText;

  /// 버튼 콜백 (null 이면 Navigator.maybePop)
  final VoidCallback? onPressed;

  /// 부제목 아래에 삽입할 추가 위젯 (선택)
  final Widget? extraContent;

  const QrBaseScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onPressed,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showAppBar: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          icon,
          AppGap.v16,
          Text(
            title,
            style: AppTextStyles.title1.withColor(context.mainTextColor),
            textAlign: TextAlign.center,
          ),
          AppGap.v12,
          Text(
            subtitle,
            style: AppTextStyles.text2.withColor(context.sub1Color),
            textAlign: TextAlign.center,
          ),
          if (extraContent != null) ...[
            AppGap.v4,
            extraContent!,
          ],
          const Spacer(),
          ConfirmButton(
            text: buttonText,
            onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}

