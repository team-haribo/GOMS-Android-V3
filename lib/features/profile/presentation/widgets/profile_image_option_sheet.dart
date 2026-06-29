import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';

/// 마이페이지 프로필 사진 변경 바텀싯 (Figma 569-10452).
class ProfileImageOptionSheet extends StatelessWidget {
  const ProfileImageOptionSheet({
    super.key,
    required this.onPickFromGallery,
    required this.onUseDefault,
  });

  final VoidCallback onPickFromGallery;
  final VoidCallback onUseDefault;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '프로필 사진 변경',
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 42),
      headerBottomSpacing: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OptionRow(
            label: '갤러리에서 선택',
            icon: AppIcons.imageAdd(
              width: 24,
              height: 24,
              color: context.mainTextColor,
            ),
            onTap: onPickFromGallery,
          ),
          const Divider(height: 1),
          _OptionRow(
            label: '기본 프로필 사용',
            icon: AppIcons.user(
              width: 24,
              height: 24,
              color: context.mainTextColor,
            ),
            onTap: onUseDefault,
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.text2.withColor(context.mainTextColor),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
