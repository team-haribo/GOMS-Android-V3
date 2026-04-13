import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/buttons/confirm_button.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';
import 'package:goms/features/qr/presentation/providers/issued_qr_provider.dart';
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

  final IssuedQrEntity value;
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
              160.0,
              math.min(
                240.0,
                math.min(
                  constraints.maxWidth * 0.64,
                  constraints.maxHeight * 0.42,
                ),
              ),
            )
            .toDouble();

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        '학생 외출·복귀용 QR',
                        style: AppTextStyles.title2.withColor(
                          context.mainTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppGap.v8,
                      Text(
                        '학생이 스캔할 수 있도록 화면을 보여주세요',
                        style: AppTextStyles.text3.withColor(context.sub2Color),
                        textAlign: TextAlign.center,
                      ),
                      AppGap.v24,
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
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
                            AppGap.v24,
                            Text(
                              'QR 만료까지',
                              style: AppTextStyles.caption1.withColor(
                                context.sub2Color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AppGap.v4,
                            Text(
                              _remainingText,
                              style: AppTextStyles.title2.withColor(
                                context.mainTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ConfirmButton(text: 'QR 다시 발급하기', onPressed: widget.onRefresh),
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
