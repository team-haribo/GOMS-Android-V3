import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/domain/enum/role_enum.dart';
import 'package:project_setting/presentation/auth/auth_provider.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/toggle_button.dart';
import 'package:project_setting/widgets/common/goms_dialog.dart';

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
}

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  AppThemeOption _selectedTheme = AppThemeOption.system;

  void _showThemePicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: AppThemeOption.values.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedTheme = option);
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

  bool _showClock = false;
  bool _outingPushAlarm = true;
  bool _cameraLaunch = true;

  // TODO: 실제 데이터 연동 시 교체
  final String _name = '김민솔';
  final int _grade = 8;
  final String _major = 'AI';
  final int _lateCount = 11;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.mainTextDark : AppColors.mainText;
    final subColor = isDark ? AppColors.sub1Dark : AppColors.sub1;
    final sub2Color = isDark ? AppColors.sub2Dark : AppColors.sub2;
    final surfaceColor = isDark ? AppColors.bgSurfaceDark : AppColors.bgSurface;

    return BaseScaffold(
      showAppBarLogo: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== 프로필 카드 ====================
            _buildProfileCard(isDark, textColor, sub2Color, surfaceColor),

            AppGap.v24,

            const Divider(),

            AppGap.v24,

            // ==================== 앱 테마 설정 ====================
            Text(
              '앱 테마 설정',
              style: AppTextStyles.caption1.withColor(
                  isDark ? AppColors.mainTextDark : AppColors.mainText),
            ),
            AppGap.v12,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showThemePicker(context),
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
                        _selectedTheme.label,
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
              value: _showClock,
              onChanged: (v) =>
                  setState(() => _showClock = v), // TODO: API 연결시 기능 구현
              textColor: textColor,
              subColor: sub2Color,
            ),
            const SizedBox(
              height: 36,
            ),
            _buildToggleItem(
              title: '외출제 푸시 알림',
              description: '외출할 시간이 될 때마다 알려드려요',
              value: _outingPushAlarm,
              onChanged: (v) =>
                  setState(() => _outingPushAlarm = v), // TODO: API 연결시 기능 구현
              textColor: textColor,
              subColor: sub2Color,
            ),
            const SizedBox(
              height: 36,
            ),
            _buildToggleItem(
              title: '카메라 바로 켜기',
              description: '앱을 실행하면 즉시 카메라가 켜져요',
              value: _cameraLaunch,
              onChanged: (v) =>
                  setState(() => _cameraLaunch = v), // TODO: API 연결시 기능 구현
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
              onTap: () => GomsDialog.showConfirm(
                context: context,
                title: '로그아웃',
                content: '로그아웃 하시겠습니까?',
                confirmText: '로그아웃',
                onConfirm: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go(RoutePath.onboarding);
                },
              ),
            ),
            _buildMenuRow(
              icon: Icons.person_remove_outlined,
              title: '회원탈퇴',
              textColor: AppColors.negative,
              onTap: () => GomsDialog.showConfirm(
                context: context,
                title: '회원 탈퇴',
                content: '정말로 회원을 탈퇴하시겠습니까?',
                confirmText: '탈퇴 하기',
                isDestructive: true,
                onConfirm: () {
                  //TODO: 회원탈퇴 페이지 구현
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 프로필 카드 ====================
  Widget _buildProfileCard(
    bool isDark,
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
              child: AppIcons.edit(),
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
          type: RoleEnum.user,
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
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              color: isDark ? AppColors.mainTextDark : AppColors.mainText,
            ),
          ],
        ),
      ),
    );
  }
}
