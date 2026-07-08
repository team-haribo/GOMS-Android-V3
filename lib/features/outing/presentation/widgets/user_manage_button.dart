import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';

class UserManageButton extends StatelessWidget {
  final double? size;

  const UserManageButton({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 64.0;

    return GradientFloatingActionButton(
      size: buttonSize,
      baseColor: AppColors.admin,
      onPressed: () => context.push(RoutePath.studentCouncilMembers),
      child: AppIcons.userManageButton(
        width: 24,
        height: 24,
        color: Colors.white,
      ),
    );
  }
}
