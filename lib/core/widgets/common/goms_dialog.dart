import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';

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
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? AppColors.mainText : AppColors.mainTextDark;

    void onConfirmPressed() {
      Navigator.of(context).pop();
      onConfirm?.call();
    }

    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title, style: TextStyle(color: textColor)),
        content: Text(content, style: TextStyle(color: textColor)),
        actions: cancelText != null
            ? [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
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
                  child: Text(confirmText),
                ),
              ]
            : [
                CupertinoDialogAction(
                  onPressed: onConfirmPressed,
                  child: Text(confirmText),
                ),
              ],
      ),
    );
  }

  ///  후기 삭제 다이얼로그
  static Future<void> reviewRemove({
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
              GomsDialog.reviewRemoveConfirm(
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
  static Future<void> reviewRemoveConfirm({
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

  /// 후기 신고 다이얼로그
  static Future<void> reviewReport({
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
              GomsDialog.reviewReportConfirm(
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
  static Future<void> reviewReportConfirm({
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
}
