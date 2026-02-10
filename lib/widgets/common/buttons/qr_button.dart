import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/domain/enum/role_enum.dart';

class QRButton extends StatelessWidget {
  /// QR 버튼 타입
  final RoleEnum type;

  /// 버튼 클릭 콜백
  final VoidCallback? onPressed;

  /// 버튼 크기 (기본값: 64)
  final double? size;

  /// 아이콘 크기 (기본값: 36)
  final double? iconSize;

  const QRButton({
    super.key,
    required this.type,
    this.onPressed,
    this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 64.0;
    final iconSizeValue = iconSize ?? 36.0;

    // 타입별 색상과 아이콘
    final backgroundColor = type == RoleEnum.user
        ? AppColors.mainColor
        : AppColors.admin;

    final icon = type == RoleEnum.user
        ? AppIcons.qrCodeScan(
            width: iconSizeValue,
            height: iconSizeValue,
            color: Colors.white,
          )
        : AppIcons.qrCodeLoad(
            width: iconSizeValue,
            height: iconSizeValue,
            color: Colors.white,
          );

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: icon,
      ),
    );
  }
}
