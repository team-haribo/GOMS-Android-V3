import 'package:flutter/cupertino.dart';

/// 공통 확인 다이얼로그 (Cupertino 스타일)
class GomsDialog {
  GomsDialog._();

  /// 확인 다이얼로그 표시 (버튼 1개)
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
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

  /// 취소/확인 다이얼로그 표시 (버튼 2개)
  static Future<void> showConfirm({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = '취소',
    String confirmText = '확인',
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
                color: CupertinoColors.systemBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
