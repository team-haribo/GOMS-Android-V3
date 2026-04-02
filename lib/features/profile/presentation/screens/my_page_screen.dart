import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/enums/app_theme_option.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/password_reset/data/providers/password_reset_data_providers.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_provider.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_provider.dart';
import 'package:goms/features/member/presentation/viewmodels/current_member_provider.dart';
import 'package:goms/features/outing/presentation/viewmodels/my_outing_status_provider.dart';
import 'package:goms/features/profile/presentation/widgets/account_actions_section.dart';
import 'package:goms/features/profile/presentation/widgets/profile_summary_section.dart';
import 'package:goms/features/profile/presentation/providers/settings_provider.dart';
import 'package:goms/features/profile/presentation/widgets/settings_section.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/dialogs/goms_dialog.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  void _showThemePicker(BuildContext context, AppThemeOption current) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: AppThemeOption.values.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(option.themeMode);
              context.pop();
            },
            child: Text(
              option.label,
              style: AppTextStyles.text2.withColor(CupertinoColors.systemBlue),
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => context.pop(),
          child: Text(
            '취소',
            style: AppTextStyles.text1.withColor(CupertinoColors.systemBlue),
          ),
        ),
      ),
    );
  }

  void _showPermissionDeniedSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 기능을 사용하려면 권한이 필요합니다.')),
    );
  }

  Future<void> _startPasswordResetFlow(String? email) async {
    final trimmedEmail = email?.trim() ?? '';
    if (trimmedEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 정보를 찾을 수 없습니다. 다시 로그인해주세요.')),
      );
      return;
    }

    try {
      await ref.read(passwordResetRepositoryProvider).sendEmailVerification(
            email: trimmedEmail,
            purpose: EmailVerificationPurpose.passwordChange,
          );
      ref.read(authFlowProvider.notifier).startResetPassword(trimmedEmail);

      if (!mounted) {
        return;
      }

      context.push(RoutePath.verify, extra: RoutePath.resetPassword);
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(NetworkException.fromDioException(error).message),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider);
    final currentMember = switch (ref.watch(currentMemberProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final myOutingStatus = switch (ref.watch(myOutingStatusProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final textColor = context.mainTextColor;
    final subColor = context.sub1Color;
    final sub2Color = context.sub2Color;
    final surfaceColor = context.surfaceColor;

    final currentThemeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final selectedThemeOption = currentThemeMode.option;

    final settings = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final showClock = settings?.showClock ?? false;
    final outingPushAlarm = settings?.outingPushAlarm ?? true;
    final cameraLaunch = settings?.cameraLaunch ?? false;

    return BaseScaffold(
      showAppBarLogo: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSummarySection(
              role: role,
              name: myOutingStatus?.name ?? currentMember?.name ?? '정보 없음',
              grade: myOutingStatus?.grade,
              major: myOutingStatus?.department,
              lateCount: null,
              textColor: textColor,
              subColor: sub2Color,
              surfaceColor: surfaceColor,
            ),
            AppGap.v24,
            const Divider(),
            AppGap.v24,
            SettingsSection(
              selectedThemeOption: selectedThemeOption,
              showClock: showClock,
              outingPushAlarm: outingPushAlarm,
              cameraLaunch: cameraLaunch,
              textColor: textColor,
              subColor: subColor,
              surfaceColor: surfaceColor,
              role: role,
              onTapTheme: () => _showThemePicker(context, selectedThemeOption),
              onToggleShowClock: (value) {
                ref.read(settingsProvider.notifier).setShowClock(value);
              },
              onToggleOutingPushAlarm: (value) async {
                final granted = await ref
                    .read(settingsProvider.notifier)
                    .setOutingPushAlarm(value);
                if (!granted && mounted) {
                  _showPermissionDeniedSnackBar('외출제 푸시 알림');
                }
              },
              onToggleCameraLaunch: (value) async {
                final granted = await ref
                    .read(settingsProvider.notifier)
                    .setCameraLaunch(value);
                if (!granted && mounted) {
                  _showPermissionDeniedSnackBar('카메라 바로 켜기');
                }
              },
            ),
            AppGap.v24,
            const Divider(),
            AppGap.v24,
            AccountActionsSection(
              textColor: textColor,
              onTapResetPassword: () =>
                  _startPasswordResetFlow(currentMember?.email),
              onTapLogout: () => GomsDialog.confirm(
                title: '로그아웃',
                content: '로그아웃 하시겠습니까?',
                confirmText: '로그아웃',
                onConfirm: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(RoutePath.onboarding);
                  }
                },
              ).show(context),
              onTapDeleteAccount: () => context.push(RoutePath.deleteAccount),
            ),
          ],
        ),
      ),
    );
  }
}
