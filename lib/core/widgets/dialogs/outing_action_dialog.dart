import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

/// 외출/외출금지 관리용 확인 다이얼로그.
///
/// 강제외출·복귀·외출금지·외출금지 해제는 문구와 버튼 라벨만 다르고 배색이 같아
/// 하나로 합쳤다. 취소는 파랑, 확인은 [AppColors.negative].
///
/// [redContent]를 주면 [content]와 [content2] 사이에 강조색으로 끼워 넣는다.
Future<void> showOutingActionDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmText,
  String? redContent,
  String? content2,
  String cancelText = '취소',
  VoidCallback? onConfirm,
  bool isDestructive = false,
}) {
  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(title),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: dialogContext.isLightMode ? Colors.black : Colors.white,
          ),
          children: [
            TextSpan(text: content),
            if (redContent != null)
              TextSpan(
                text: redContent,
                style: const TextStyle(color: AppColors.negative),
              ),
            if (content2 != null) TextSpan(text: content2),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            cancelText,
            style: const TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          onPressed: () {
            Navigator.of(dialogContext).pop();
            onConfirm?.call();
          },
          child: Text(
            confirmText,
            style: const TextStyle(color: AppColors.negative),
          ),
        ),
      ],
    ),
  );
}
