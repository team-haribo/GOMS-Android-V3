import 'package:flutter/cupertino.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';

/// 공통 확인 다이얼로그 (Cupertino 스타일)
class GomsDialog {
  const GomsDialog._({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.barrierDismissible,
    required this.isDestructive,
    this.cancelText,
    this.onConfirm,
  });

  /// 확인 다이얼로그 (버튼 1개)
  factory GomsDialog.single({
    required String title,
    required String content,
    String confirmText = '확인',
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
  }) =>
      GomsDialog._(
        title: title,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
        barrierDismissible: barrierDismissible,
        isDestructive: false,
      );

  /// 취소/확인 다이얼로그 (버튼 2개)
  factory GomsDialog.confirm({
    required String title,
    required String content,
    String cancelText = '취소',
    String confirmText = '확인',
    VoidCallback? onConfirm,
    bool isDestructive = false,
  }) =>
      GomsDialog._(
        title: title,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
        onConfirm: onConfirm,
        barrierDismissible: true,
        isDestructive: isDestructive,
      );

  final String title;
  final String content;
  final String? cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final bool barrierDismissible;
  final bool isDestructive;

  Future<void> show(BuildContext context) {
    final textColor = context.mainTextColor;

    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        void onConfirmPressed() {
          Navigator.of(dialogContext).pop();
          onConfirm?.call();
        }

        return CupertinoAlertDialog(
          title: Text(title, style: TextStyle(color: textColor)),
          content: Text(content, style: TextStyle(color: textColor)),
          actions: cancelText != null
              ? [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      cancelText!,
                      style: isDestructive
                          ? null
                          : const TextStyle(color: AppColors.negative),
                    ),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: isDestructive,
                    onPressed: onConfirmPressed,
                    child: Text(confirmText, style: const TextStyle(color: AppColors.blue),),
                  ),
                ]
              : [
                  CupertinoDialogAction(
                    onPressed: onConfirmPressed,
                    child: Text(confirmText, style: const TextStyle(color: AppColors.blue,),),
                  ),
                ],
        );
      },
    );
  }
}
