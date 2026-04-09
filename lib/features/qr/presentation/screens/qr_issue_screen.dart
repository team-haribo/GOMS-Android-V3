import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/buttons/confirm_button.dart';
import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';
import 'package:goms/features/qr/presentation/providers/issued_qr_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

final _qrRemainingProvider =
    StreamProvider.autoDispose.family<Duration, IssuedQrEntity>((ref, value) async* {
      Duration remaining() {
        const qrLifetime = Duration(minutes: 5);
        final serverExpiresAt = DateTime.fromMillisecondsSinceEpoch(
          value.exp * 1000,
          isUtc: true,
        ).toLocal();
        final clientExpiresAt = value.issuedAt.add(qrLifetime);
        final expiresAt = serverExpiresAt.isBefore(clientExpiresAt)
            ? serverExpiresAt
            : clientExpiresAt;
        final diff = expiresAt.difference(DateTime.now());
        return diff.isNegative ? Duration.zero : diff;
      }

      yield remaining();
      final timer = Stream.periodic(const Duration(seconds: 1), (_) => remaining());
      yield* timer;
    });

class QrIssueScreen extends ConsumerWidget {
  const QrIssueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);

    if (role != RoleEnum.admin) {
      return BaseScaffold(
        showAppBar: true,
        role: role,
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

class _QrIssuedContent extends ConsumerWidget {
  const _QrIssuedContent({
    required this.value,
    required this.onRefresh,
  });

  final IssuedQrEntity value;
  final VoidCallback onRefresh;

  String _remainingText(WidgetRef ref) {
    final remaining =
        ref.watch(_qrRemainingProvider(value)).asData?.value ?? Duration.zero;
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes분 $seconds초';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrPayload = jsonEncode({
      'uuid': value.uuid,
      'exp': value.exp,
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
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '학생 외출·복귀용 QR',
                      style: AppTextStyles.title2.withColor(context.mainTextColor),
                      textAlign: TextAlign.center,
                    ),
                    AppGap.v24,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                      style: AppTextStyles.caption1.withColor(context.sub2Color),
                      textAlign: TextAlign.center,
                    ),
                    AppGap.v4,
                    Text(
                      _remainingText(ref),
                      style: AppTextStyles.title2.withColor(context.mainTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ConfirmButton(text: 'QR 다시 발급하기', onPressed: onRefresh),
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
