import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';

class UserManageButton extends StatelessWidget {
  final double? size;

  const UserManageButton({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 64.0;

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: () => context.push(RoutePath.studentCouncilMembers),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.admin,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: AppIcons.userManageButton(
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
