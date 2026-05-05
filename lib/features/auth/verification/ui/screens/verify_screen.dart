import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/auth/shared/ui/screens/auth_base_screen.dart';
import 'package:goms/features/auth/verification/ui/states/verify_state.dart';
import 'package:goms/features/auth/verification/ui/providers/verify_provider.dart';
import 'package:goms/features/auth/shared/ui/providers/auth_flow_provider.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  final String? redirectPath;
  final String? backPath;

  const VerifyScreen({super.key, this.redirectPath, this.backPath});

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  late final ProviderSubscription<VerifyState> _verifySubscription;

  String _formatRemainingTime(int remainingSeconds) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _clearVerificationState() {
    ref.read(authFlowProvider.notifier).clearVerifiedToken();
    ref.read(verifyProvider.notifier).clear();
  }

  String get _fallbackBackRoute =>
      widget.backPath ??
      (widget.redirectPath == RoutePath.resetPassword
          ? RoutePath.findPassword
          : RoutePath.signUp);

  void _handleBack() {
    _clearVerificationState();

    if (widget.backPath != null) {
      context.go(widget.backPath!);
      return;
    }

    if (widget.redirectPath == RoutePath.resetPassword) {
      context.go(RoutePath.findPassword);
      return;
    }

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(_fallbackBackRoute);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(verifyProvider.notifier).reset();
    });
    _verifySubscription = ref.listenManual<VerifyState>(verifyProvider, (
      previous,
      next,
    ) async {
      if (next.status == VerifyStatus.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          final notifier = ref.read(verifyProvider.notifier);
          notifier.resetStatus();
          final isResetFlow = widget.redirectPath == RoutePath.resetPassword;
          await GomsDialog.single(
            title: '인증 확인',
            content: isResetFlow
                ? '인증이 완료되었습니다.\n비밀번호 재설정 페이지로 이동합니다.'
                : '인증이 완료되었습니다.\n회원가입 페이지로 돌아갑니다.',
            onConfirm: () {
              context.go(widget.redirectPath ?? RoutePath.password);
            },
          ).show(context);
          notifier.reset();
        });
      } else if (next.status == VerifyStatus.failure) {
        final message = next.errorMessage ?? next.codeError;
        if (message == null) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(verifyProvider.notifier).resetStatus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.negative,
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _verifySubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verifyState = ref.watch(verifyProvider);
    final notifier = ref.read(verifyProvider.notifier);
    final isLoading = verifyState.status == VerifyStatus.loading;
    final formattedTime = _formatRemainingTime(verifyState.remainingSeconds);
    final canResend = verifyState.resendCooldownSeconds <= 0;
    final resendButtonText =
        canResend ? '재발송' : '재발송 (${verifyState.resendCooldownSeconds}s)';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: AuthBaseScreen(
        title: '인증번호',
        confirmText: '인증',
        isConfirmEnabled: notifier.isFormValid,
        onConfirm: notifier.isFormValid && !isLoading ? notifier.verify : null,
        onBackPressed: _handleBack,
        showAppBar: true,
        showAppBarLogo: false,
        isLoading: isLoading,
        children: [
          BaseTextField(
            controller: notifier.codeController,
            hintText: '인증번호를 입력해주세요',
            errorText: verifyState.codeError,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            enabled: !isLoading,
            onChanged: (value) {
              if (value.length <= 6) {
                notifier.setCode(value);
              } else {
                notifier.codeController.text = value.substring(0, 6);
                notifier.codeController.selection =
                    const TextSelection.collapsed(offset: 6);
              }
            },
            onSubmitted: (_) => notifier.verify(),
          ),
          AppGap.h12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedTime,
                style: AppTextStyles.text3.withColor(context.sub2Color),
              ),
              GestureDetector(
                onTap: isLoading || !canResend ? null : notifier.resend,
                child: Text(
                  resendButtonText,
                  style: AppTextStyles.text3.withColor(
                    canResend && !isLoading
                        ? AppColors.mainColor
                        : context.sub2Color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
