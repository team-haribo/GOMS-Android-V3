import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/config/light_theme.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:goms/features/my_page/presentation/viewmodels/settings_provider.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/buttons/toggle_button.dart';
import 'package:goms/core/widgets/common/dialogs/goms_dialog.dart';

void main() async {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: LightTheme.theme,
        themeMode: ThemeMode.light,
        home: const MyPageScreen(role: RoleEnum.admin),
      ),
    ),
  );
}

enum AppThemeOption { system, light, dark }

extension AppThemeOptionLabel on AppThemeOption {
  String get label {
    switch (this) {
      case AppThemeOption.system:
        return '시스템 테마 설정';
      case AppThemeOption.light:
        return '라이트 모드';
      case AppThemeOption.dark:
        return '다크 모드';
    }
  }

  /// AppThemeOption → ThemeMode 변환
  ThemeMode get themeMode {
    switch (this) {
      case AppThemeOption.system:
        return ThemeMode.system;
      case AppThemeOption.light:
        return ThemeMode.light;
      case AppThemeOption.dark:
        return ThemeMode.dark;
    }
  }
}

extension ThemeModeToOption on ThemeMode {
  AppThemeOption get option {
    switch (this) {
      case ThemeMode.system:
        return AppThemeOption.system;
      case ThemeMode.light:
        return AppThemeOption.light;
      case ThemeMode.dark:
        return AppThemeOption.dark;
    }
  }
}

class MyPageScreen extends ConsumerStatefulWidget {
  final RoleEnum role;

  const MyPageScreen({
    super.key,
    required this.role,
  });

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
            // ==================== 프로필 카드 ====================
            _buildProfileCard(textColor, sub2Color, surfaceColor),

            AppGap.v24,

            const Divider(),

            AppGap.v24,

            // ==================== 앱 테마 설정 ====================
            Text(
              '앱 테마 설정',
              style: AppTextStyles.caption1.withColor(textColor),
            ),
            AppGap.v12,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showThemePicker(context, selectedThemeOption),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12,
                  vertical: AppSpacing.s12,
                ),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedThemeOption.label,
                        style: AppTextStyles.text2.withColor(subColor),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: subColor,
                    ),
                  ],
                ),
              ),
            ),
            AppGap.v24,
            // ==================== 토글 항목 ====================
            _buildToggleItem(
              title: '시계 나타내기',
              description: '프로필 카드에 초 단위의 시간을 나타내요',
              value: showClock,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setShowClock(v),
              textColor: textColor,
              subColor: sub2Color,
            ),
            AppGap.v36,
            _buildToggleItem(
              title: '외출제 푸시 알림',
              description: '외출할 시간이 될 때마다 알려드려요',
              value: outingPushAlarm,
              onChanged: (v) async {
                final granted = await ref
                    .read(settingsProvider.notifier)
                    .setOutingPushAlarm(v);
                if (!granted && mounted) {
                  _showPermissionDeniedSnackBar('외출제 푸시 알림');
                }
              },
              textColor: textColor,
              subColor: sub2Color,
            ),
            AppGap.v36,
            _buildToggleItem(
              title: '카메라 바로 켜기',
              description: '앱을 실행하면 즉시 카메라가 켜져요',
              value: cameraLaunch,
              onChanged: (v) async {
                final granted = await ref
                    .read(settingsProvider.notifier)
                    .setCameraLaunch(v);
                if (!granted && mounted) {
                  _showPermissionDeniedSnackBar('카메라 바로 켜기');
                }
              },
              textColor: textColor,
              subColor: sub2Color,
            ),

            AppGap.v24,

            const Divider(),

            AppGap.v24,

            // ==================== 메뉴 항목 ====================
            _buildMenuRow(
              icon: Icons.settings_outlined,
              title: '비밀번호 재설정',
              textColor: textColor,
              onTap: () {
                context.go(RoutePath.resetPassword);
              },
            ),
            _buildMenuRow(
              icon: Icons.logout_outlined,
              title: '로그아웃',
              textColor: AppColors.negative,
              chevronColor: textColor,
              onTap: () => GomsDialog.confirm(
                title: '로그아웃',
                content: '로그아웃 하시겠습니까?',
                confirmText: '로그아웃',
                onConfirm: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go(RoutePath.onboarding);
                },
              ).show(context),
            ),
            _buildMenuRow(
              icon: Icons.person_remove_outlined,
              title: '회원탈퇴',
              textColor: AppColors.negative,
              chevronColor: textColor,
              onTap: () => context.push(RoutePath.deleteAccount),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 프로필 카드 ====================
  Widget _buildProfileCard(
    Color textColor,
    Color sub2Color,
    Color surfaceColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 아바타 + 뱃지
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: surfaceColor,
              child: ClipOval(
                child: AppIcons.profileCircle(width: 72, height: 72),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: widget.role == RoleEnum.admin
                  ? AppIcons.adminEdit()
                  : AppIcons.edit(),
            ),
          ],
        ),
        AppGap.h16,
        // 이름 / 기수·전공
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name,
                style: AppTextStyles.title3.withColor(textColor),
              ),
              AppGap.v4,
              Text(
                '$_grade기 | $_major과',
                style: AppTextStyles.caption1.withColor(sub2Color),
              ),
            ],
          ),
        ),
        // 지각 횟수
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '지각 횟수',
              style: AppTextStyles.text2.withColor(sub2Color),
            ),
            AppGap.v4,
            Text(
              '$_lateCount번',
              style: AppTextStyles.title3.withColor(AppColors.negative),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== 토글 아이템 ====================
  Widget _buildToggleItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textColor,
    required Color subColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.text1.withColor(textColor)),
              AppGap.v4,
              Text(
                description,
                style: AppTextStyles.caption1.withColor(subColor),
              ),
            ],
          ),
        ),
        ToggleButton(
          type: widget.role,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ==================== 메뉴 행 ====================
  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
    Color? chevronColor,
  }) {
    final effectiveChevronColor = chevronColor ?? textColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: textColor),
            AppGap.h2,
            Expanded(
              child:
                  Text(title, style: AppTextStyles.text2.withColor(textColor)),
            ),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: effectiveChevronColor,
            ),
          ],
        ),
      ),
    );
  }
}



