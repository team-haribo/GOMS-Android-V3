import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 후기 신고 다이얼로그
Future<void> reviewReport({
  required BuildContext context,
  required String title,
  required String content,
  String cancelText = '취소',
  String confirmText = '신고하기',
  VoidCallback? onConfirm,
  bool isDestructive = false,
}) {
  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
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
            reviewReportConfirm(
              context: context,
              title: '후기 신고 완료',
              content: '신고가 접수되었습니다.\n더 나은 GOMS가 되기위해 노력하겠습니다!',
            );
          },
          child: Text(
            confirmText,
            style: const TextStyle(
              color: CupertinoColors.systemBlue,
            ),
          ),
        ),
      ],
    ),
  );
}

/// 후기 신고 컨펌 다이얼로그
Future<void> reviewReportConfirm({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = '돌아가기',
  VoidCallback? onConfirm,
  bool barrierDismissible = false,
}) {
  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          child: Text(
            confirmText,
            style: const TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),
      ],
    ),
  );
}
