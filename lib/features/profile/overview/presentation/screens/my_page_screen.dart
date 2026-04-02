import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_provider.dart';
import 'package:goms/features/member/presentation/viewmodels/current_member_provider.dart';
import 'package:goms/features/profile/account/presentation/widgets/account_actions_section.dart';
import 'package:goms/features/profile/overview/presentation/widgets/profile_summary_section.dart';
import 'package:goms/features/profile/settings/presentation/viewmodels/settings_provider.dart';
import 'package:goms/features/profile/settings/presentation/widgets/settings_section.dart';
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

  // TODO: 실제 데이터 연동 시 교체
  final String _name = '김민솔';
  final int _grade = 8;
  final String _major = 'AI';
  final int _lateCount = 11;

  void _showPermissionDeniedSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 기능을 사용하려면 권한이 필요합니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider);
    final currentMember = switch (ref.watch(currentMemberProvider)) {
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
              name: currentMember?.name ?? _name,
              grade: _grade,
              major: _major,
              lateCount: _lateCount,
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
              onTapResetPassword: () => context.go(RoutePath.resetPassword),
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
