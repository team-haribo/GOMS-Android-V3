import 'package:flutter/material.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/buttons/toggle_button.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.selectedThemeOption,
    required this.showClock,
    required this.outingPushAlarm,
    required this.cameraLaunch,
    required this.textColor,
    required this.subColor,
    required this.surfaceColor,
    required this.role,
    required this.sectionSpacing,
    required this.themeTileVerticalPadding,
    required this.onTapTheme,
    required this.onToggleShowClock,
    required this.onToggleOutingPushAlarm,
    required this.onToggleCameraLaunch,
  });

  final AppThemeOption selectedThemeOption;
  final bool showClock;
  final bool outingPushAlarm;
  final bool cameraLaunch;
  final Color textColor;
  final Color subColor;
  final Color surfaceColor;
  final RoleEnum role;
  final double sectionSpacing;
  final double themeTileVerticalPadding;
  final VoidCallback onTapTheme;
  final ValueChanged<bool> onToggleShowClock;
  final ValueChanged<bool> onToggleOutingPushAlarm;
  final ValueChanged<bool> onToggleCameraLaunch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '앱 테마 설정',
          style: AppTextStyles.text1.withColor(context.mainTextColor),
        ),
        AppGap.v12,
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTapTheme,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: themeTileVerticalPadding,
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
                Icon(Icons.keyboard_arrow_down_rounded, color: subColor),
              ],
            ),
          ),
        ),
        SizedBox(height: sectionSpacing),
        _SettingsToggleItem(
          title: '시계 나타내기',
          description: '프로필 카드에 초 단위의 시간을 나타내요',
          value: showClock,
          onChanged: onToggleShowClock,
          textColor: textColor,
          subColor: subColor,
          role: role,
        ),
        if (role != RoleEnum.admin) ...[
          SizedBox(height: sectionSpacing),
          _SettingsToggleItem(
            title: '외출제 푸시 알림',
            description: '외출할 시간이 될 때마다 알려드려요',
            value: outingPushAlarm,
            onChanged: onToggleOutingPushAlarm,
            textColor: textColor,
            subColor: subColor,
            role: role,
          ),
        ],
        SizedBox(height: sectionSpacing),
        _SettingsToggleItem(
          title: role == RoleEnum.admin ? 'QR 생성 바로 켜기' : '카메라 바로 켜기',
          description: role == RoleEnum.admin
              ? '앱을 실행하면 즉시 QR 발급 화면이 열려요'
              : '앱을 실행하면 즉시 카메라가 켜져요',
          value: cameraLaunch,
          onChanged: onToggleCameraLaunch,
          textColor: textColor,
          subColor: subColor,
          role: role,
        ),
      ],
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  const _SettingsToggleItem({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.textColor,
    required this.subColor,
    required this.role,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color textColor;
  final Color subColor;
  final RoleEnum role;

  @override
  Widget build(BuildContext context) {
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
        ToggleButton(type: role, value: value, onChanged: onChanged),
      ],
    );
  }
}
