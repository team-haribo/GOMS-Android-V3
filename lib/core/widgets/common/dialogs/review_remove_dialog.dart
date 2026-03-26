import 'package:flutter/cupertino.dart';

///  후기 삭제 다이얼로그
Future<void> reviewRemove({
  required BuildContext context,
  required String title,
  required String content,
  String cancelText = '취소',
  String confirmText = '삭제하기',
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
            reviewRemoveConfirm(
              context: context,
              title: '후기 삭제 완료',
              content: '\n후기 삭제를 성공적으로 완료했습니다.',
            );
            onConfirm?.call();
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

/// 후기 삭제 컨펌 다이얼로그
Future<void> reviewRemoveConfirm({
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
