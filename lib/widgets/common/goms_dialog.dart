import 'package:flutter/cupertino.dart';

/// 공통 확인 다이얼로그 (Cupertino 스타일)
class GomsDialog {
  GomsDialog._();

  /// 확인 다이얼로그 표시
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
        title: Text(
          title,
        ),
        content: Text(
          content,
        ),
        actions: [
          CupertinoDialogAction(
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
