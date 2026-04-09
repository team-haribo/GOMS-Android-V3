import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/enums/role_enum.dart';

class QRButton extends StatelessWidget {
  /// QR 버튼 타입
  final RoleEnum type;

  /// 버튼 크기 (기본값: 64)
  final double? size;

  /// 아이콘 크기 (기본값: 36)
  final double? iconSize;

  final Widget? floatingActionButton;

  const QRButton({
    super.key,
    required this.type,
    this.size,
    this.iconSize,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 64.0;
    final iconSizeValue = iconSize ?? 36.0;

    // 타입별 색상과 아이콘
    final backgroundColor =
        type == RoleEnum.user ? AppColors.mainColor : AppColors.admin;

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
        onPressed: () {
          context
              .push(type == RoleEnum.admin ? RoutePath.qrIssue : RoutePath.qr);
        },
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
