import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/outing/presentation/providers/current_outing_students_provider.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';
import 'package:goms_design_system/goms_design_system.dart';

class QRButton extends ConsumerWidget {
  final RoleEnum type;
  final double? size;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonSize = size ?? 64.0;
    final iconSizeValue = iconSize ?? 36.0;

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

    return GradientFloatingActionButton(
      size: buttonSize,
      baseColor: backgroundColor,
      onPressed: () async {
        await context.push(
          type == RoleEnum.admin ? RoutePath.qrIssue : RoutePath.qr,
        );
        if (context.mounted) {
          ref.read(currentOutingStudentsProvider.notifier).reload();
          ref.read(myOutingStatusProvider.notifier).reload();
        }
      },
      child: icon,
    );
  }
}