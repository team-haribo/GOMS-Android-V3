import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/widgets/buttons/toggle_button.dart';
import 'package:goms/features/profile/presentation/viewmodels/settings_viewmodel.dart';
import 'package:goms/features/profile/presentation/widgets/theme_setting_item.dart';
import 'package:goms_design_system/goms_design_system.dart';

/// 마이페이지 설정 묶음 (Figma 569-10165)
class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  /// 권한이 거부돼 토글이 되돌아갈 때 알린다.
  void _showPermissionDenied(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 기능을 사용하려면 권한이 필요합니다.')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final isAdmin = role == RoleEnum.admin;

    final selectedThemeOption = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value.option,
      _ => AppThemeOption.system,
    };
    final settings = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final showClock = settings?.showClock ?? false;
    final outingPushAlarm = settings?.outingPushAlarm ?? true;
    final cameraLaunch = settings?.cameraLaunch ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThemeSettingItem(
          selected: selectedThemeOption,
          onSelected: (option) => ref
              .read(themeModeProvider.notifier)
              .setThemeMode(option.themeMode),
        ),
        SizedBox(height: 14.h),
        _SettingsToggleItem(
          title: '시계 나타내기',
          description: '프로필 카드에 초 단위의 시간을 나타내요',
          value: showClock,
          onChanged: (value) =>
              ref.read(settingsProvider.notifier).setShowClock(value),
          role: role,
        ),
        if (!isAdmin) ...[
          SizedBox(height: 14.h),
          _SettingsToggleItem(
            title: '외출제 푸시 알림',
            description: '외출할 시간이 될 때마다 알려드려요',
            value: outingPushAlarm,
            onChanged: (value) async {
              final granted = await ref
                  .read(settingsProvider.notifier)
                  .setOutingPushAlarm(value);
              if (!granted && context.mounted) {
                _showPermissionDenied(context, '외출제 푸시 알림');
              }
            },
            role: role,
          ),
        ],
        SizedBox(height: 14.h),
        _SettingsToggleItem(
          title: isAdmin ? 'QR 생성 바로 켜기' : '카메라 바로 켜기',
          description: isAdmin
              ? '앱을 실행하면 즉시 QR 발급 화면이 열려요'
              : '앱을 실행하면 즉시 카메라가 켜져요',
          value: cameraLaunch,
          onChanged: (value) async {
            final granted = await ref
                .read(settingsProvider.notifier)
                .setCameraLaunch(value);
            if (!granted && context.mounted) {
              _showPermissionDenied(
                context,
                isAdmin ? 'QR 생성 바로 켜기' : '카메라 바로 켜기',
              );
            }
          },
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
    required this.role,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final RoleEnum role;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.text1.withColor(context.mainTextColor)),
              SizedBox(height: 4.h),
              Text(
                description,
                style: AppTextStyles.caption1.withColor(context.sub2Color),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          child: ToggleButton(type: role, value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}
