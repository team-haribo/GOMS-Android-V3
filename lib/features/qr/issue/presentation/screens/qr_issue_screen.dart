import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/buttons/confirm_button.dart';
import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';
import 'package:goms/features/qr/issue/presentation/viewmodels/issued_qr_provider.dart';
import 'package:intl/intl.dart';
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

class _QrIssuedContent extends StatelessWidget {
  const _QrIssuedContent({
    required this.value,
    required this.onRefresh,
  });

  final IssuedQrEntity value;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      value.exp * 1000,
      isUtc: true,
    ).toLocal();
    final qrPayload = jsonEncode({
      'uuid': value.uuid,
      'exp': value.exp,
    });

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'QR 발급',
            style: AppTextStyles.title1.withColor(context.mainTextColor),
          ),
        ),
        AppGap.v24,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                '학생 외출·복귀용 QR',
                style: AppTextStyles.title3.withColor(context.mainTextColor),
              ),
              AppGap.v20,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: qrPayload,
                  size: 240,
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
              AppGap.v20,
              Text(
                '만료 시간',
                style: AppTextStyles.caption1.withColor(context.sub2Color),
              ),
              AppGap.v4,
              Text(
                DateFormat('yyyy.MM.dd HH:mm:ss').format(expiresAt),
                style: AppTextStyles.text1.withColor(context.mainTextColor),
              ),
            ],
          ),
        ),
        const Spacer(),
        ConfirmButton(text: 'QR 다시 발급하기', onPressed: onRefresh),
      ],
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
