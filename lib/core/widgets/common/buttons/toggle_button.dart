import 'package:flutter/material.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';

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
    final isEnabled = onChanged != null;

    final activeColor = type == RoleEnum.user ? AppColors.mainColor : AppColors.admin;

    return Switch(
      value: value,
      onChanged: isEnabled ? onChanged : null,
      activeThumbColor: Colors.white,
      activeTrackColor: activeColor,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: context.sub2Color,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
