import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';

/// 외출금지 해제
Future<void> bannedOutingRelease({
  required BuildContext context,
  required String title,
  required String content,
  required String redContent,
  required String content2,
  String cancelText = '취소',
  String confirmText = '외출 해제',
  VoidCallback? onConfirm,
  bool isDestructive = false,
}) {

  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: context.isLightMode ? Colors.black : Colors.white),
          children: [
            TextSpan(text: content),
            TextSpan(
                text: redContent,
                style: const TextStyle(color: AppColors.negative),),
            TextSpan(text: content2),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: const TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          onPressed: () {
            Navigator.of(context).pop();
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
