import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';

class DragHandleHeader extends SliverPersistentHeaderDelegate {

  @override
  double get minExtent => 36;

  @override
  double get maxExtent => 36;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {

    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      color: isLight ?  AppColors.bgSurface : AppColors.bgSurfaceDark,
      child: Center(
        child: Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.sub2,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant DragHandleHeader oldDelegate) {
    return false;
  }
}