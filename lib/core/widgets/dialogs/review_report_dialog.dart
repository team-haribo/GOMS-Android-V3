import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goms/core/theme/colors/app_colors.dart';

/// 후기 신고 다이얼로그
Future<void> reviewReport({
  required BuildContext context,
  required String title,
  required String content,
  String cancelText = '취소',
  String confirmText = '신고하기',
  int maxReasonLength = 100,
  FutureOr<void> Function(String reason)? onConfirm,
}) {
  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => _ReviewReportDialog(
      title: title,
      content: content,
      cancelText: cancelText,
      confirmText: confirmText,
      maxReasonLength: maxReasonLength,
      onConfirm: onConfirm,
    ),
  );
}

class _ReviewReportDialog extends StatefulWidget {
  const _ReviewReportDialog({
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
    required this.maxReasonLength,
    required this.onConfirm,
  });

  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final int maxReasonLength;
  final FutureOr<void> Function(String reason)? onConfirm;

  @override
  State<_ReviewReportDialog> createState() => _ReviewReportDialogState();
}

class _ReviewReportDialogState extends State<_ReviewReportDialog> {
  final TextEditingController _reasonController = TextEditingController();
  String _reason = '';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reasonLength = _reason.length;
    final canSubmit = _reason.trim().isNotEmpty && !_isSubmitting;

    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Column(
        children: [
          Text(widget.content),
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: _reasonController,
            placeholder: '신고 사유 작성',
            maxLines: 1,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxReasonLength),
            ],
            onChanged: (value) {
              setState(() {
                _reason = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$reasonLength/${widget.maxReasonLength}',
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(
            widget.cancelText,
            style: const TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: canSubmit ? _submit : null,
          child: Text(
            widget.confirmText,
            style: TextStyle(
              color: canSubmit
                  ? CupertinoColors.systemRed
                  : CupertinoColors.systemGrey,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final reason = _reason.trim();
    if (reason.isEmpty || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onConfirm?.call(reason);
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
      await reviewReportConfirm(
        context: context,
        title: '후기 신고 완료',
        content: '신고가 접수되었습니다.\n더 나은 GOMS가 되기위해 노력하겠습니다!',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('후기 신고에 실패했습니다.'),
          backgroundColor: AppColors.negative,
        ),
      );
    }
  }
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
