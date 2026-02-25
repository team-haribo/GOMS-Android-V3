import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/domain/enum/role_enum.dart';

class ToggleButton extends StatelessWidget {
  final RoleEnum type;

  /// 토글 상태 (True/False)
  final bool value;

  /// 상태 변경 콜백
  final ValueChanged<bool>? onChanged;

  const ToggleButton({
    super.key,
    required this.type,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onChanged != null;

    // 활성화 색상 (User/Admin)
    final activeColor = type == RoleEnum.user
        ? AppColors
              .mainColor // User: 주황색
        : AppColors.admin; // Admin: 보라색

    // 비활성화 색상 (Dark/Light 모드)
    final inactiveColor = isDarkMode
        ? AppColors
              .sub2Dark // Dark 모드: 어두운 회색
        : AppColors.sub2; // Light 모드: 밝은 회색

    return Switch(
      value: value,
      onChanged: isEnabled ? onChanged : null,
      activeThumbColor: Colors.white, // thumb 색상
      activeTrackColor: activeColor, // 활성화 track
      inactiveThumbColor: Colors.white, // 비활성 thumb
      inactiveTrackColor: inactiveColor, // 비활성 track
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
