import 'package:flutter/cupertino.dart';
import 'package:goms_design_system/goms_design_system.dart';

///  후기 삭제 다이얼로그
Future<void> forcedReturn({
  required BuildContext context,
  required String title,
  required String content,
  String cancelText = '취소',
  String confirmText = '복귀',
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
            onConfirm?.call();
          },
          child: Text(
            confirmText,
            style: const TextStyle(
              color: AppColors.negative,
            ),
          ),
        ),
      ],
    ),
  );
}
