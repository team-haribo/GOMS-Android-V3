import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';

class ViewMoreUsers extends StatelessWidget {
  const ViewMoreUsers({
    super.key,
    this.path = RoutePath.outingState,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 24),
      child: ElevatedButton(
        onPressed: () {
          context.push(path);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 24),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: context.surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: Text(
          "더보기",
          style: AppTextStyles.caption2.copyWith(
            fontWeight: FontWeight.w300,
            color: context.isLightMode ? context.sub2Color : context.sub1Color,
          ),
        ),
      ),
    );
  }
}
