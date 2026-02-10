import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';

/// 토글 버튼 타입
enum ToggleType {
  /// User 토글 (주황색)
  user,

  /// Admin 토글 (보라색)
  admin,
}

/// 토글 버튼 위젯
///
/// 활성화 상태:
/// - User: 주황색 (primary)
/// - Admin: 보라색 (admin)
///
/// 비활성화 상태:
/// - Dark 모드: 어두운 회색
/// - Light 모드: 밝은 회색 (button)
class CustomToggleButton extends StatelessWidget {
  /// 토글 타입 (User/Admin)
  final ToggleType type;

  /// 토글 상태 (True/False)
  final bool value;

  /// 상태 변경 콜백
  final ValueChanged<bool>? onChanged;

  const CustomToggleButton({
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
    final activeColor = type == ToggleType.user
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
