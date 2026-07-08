import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

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
    return Container(
      color: context.surfaceColor,
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
