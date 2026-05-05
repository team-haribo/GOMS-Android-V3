import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/features/qr/ui/models/issued_qr_model.dart';
import 'package:goms/features/qr/ui/providers/issued_qr_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrIssueScreen extends ConsumerWidget {
  const QrIssueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);

    if (role != RoleEnum.admin) {
      return BaseScaffold(
        showAppBar: true,
        role: role,
        onBackPressed: () => context.go(RoutePath.home),
        body: Center(
          child: Text(
            '학생회만 QR을 발급할 수 있어요.',
            style: AppTextStyles.text1.withColor(context.mainTextColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final issuedQr = ref.watch(issuedQrProvider);

    return BaseScaffold(
      showAppBar: true,
      role: role,
      onBackPressed: () => context.go(RoutePath.home),
      body: issuedQr.when(
        data: (value) => _QrIssuedContent(
          value: value,
          onRefresh: () => ref.read(issuedQrProvider.notifier).reload(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _QrIssueError(
          message: error is IssueQrException ? error.message : 'QR 발급에 실패했어요.',
          onRetry: () => ref.read(issuedQrProvider.notifier).reload(),
        ),
      ),
    );
  }
}

class _QrIssuedContent extends StatefulWidget {
  const _QrIssuedContent({
    required this.value,
    required this.onRefresh,
  });

  final IssuedQrModel value;
  final VoidCallback onRefresh;

  @override
  State<_QrIssuedContent> createState() => _QrIssuedContentState();
}

class _QrIssuedContentState extends State<_QrIssuedContent> {
  static const Duration _qrLifetime = Duration(minutes: 5);

  Timer? _timer;
  late Duration _remaining;

  DateTime get _expiresAt {
    final serverExpiresAt = DateTime.fromMillisecondsSinceEpoch(
      widget.value.exp * 1000,
      isUtc: true,
    ).toLocal();
    final clientExpiresAt = widget.value.issuedAt.add(_qrLifetime);

    return serverExpiresAt.isBefore(clientExpiresAt)
        ? serverExpiresAt
        : clientExpiresAt;
  }

  bool get _isExpired => _remaining == Duration.zero;

  @override
  void initState() {
    super.initState();
    _remaining = _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = _calculateRemaining();
      });
    });
  }

  @override
  void didUpdateWidget(covariant _QrIssuedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value.uuid != widget.value.uuid ||
        oldWidget.value.exp != widget.value.exp ||
        oldWidget.value.issuedAt != widget.value.issuedAt) {
      _remaining = _calculateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration _calculateRemaining() {
    final diff = _expiresAt.difference(DateTime.now());
    if (diff.isNegative) {
      return Duration.zero;
    }
    return diff;
  }

  String get _remainingText {
    final minutes =
        _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes분 $seconds초';
  }

  @override
  Widget build(BuildContext context) {
    final qrPayload = jsonEncode({
      'uuid': widget.value.uuid,
      'exp': widget.value.exp,
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final qrSize = math
            .max(
              180.0,
              math.min(
                220.0,
                math.min(
                  constraints.maxWidth * 0.62,
                  constraints.maxHeight * 0.34,
                ),
              ),
            )
            .toDouble();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '외출 QR코드',
              style: AppTextStyles.title1.withColor(context.mainTextColor),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: QrImageView(
                          data: qrPayload,
                          size: qrSize,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'QR코드 만료까지',
                      style:
                          AppTextStyles.caption1.withColor(context.sub2Color),
                      textAlign: TextAlign.center,
                    ),
                    AppGap.v4,
                    Text(
                      _remainingText,
                      style: AppTextStyles.title1.withColor(AppColors.admin),
                      textAlign: TextAlign.center,
                    ),
                    if (_isExpired) ...[
                      AppGap.v24,
                      SizedBox(
                        width: math.min(constraints.maxWidth, 280),
                        child: ConfirmButton(
                          text: 'QR 다시 발급하기',
                          onPressed: widget.onRefresh,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QrIssueError extends StatelessWidget {
  const _QrIssueError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: AppTextStyles.text1.withColor(context.mainTextColor),
            textAlign: TextAlign.center,
          ),
          AppGap.v16,
          ConfirmButton(text: '다시 시도', onPressed: onRetry),
        ],
      ),
    );
  }
}
