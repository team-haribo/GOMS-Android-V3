import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';

class MapBottomSheet extends StatelessWidget {
  const MapBottomSheet({
    super.key,
    required this.isLight,
    required this.slivers,
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
    required this.snapSizes,
    this.onExtentChanged,
    this.controller,
  });

  final bool isLight;
  final List<Widget> slivers;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final List<double> snapSizes;
  final ValueChanged<double>? onExtentChanged;
  final DraggableScrollableController? controller;

  static double handleOnlyMinSize(BuildContext context) =>
      MediaQuery.sizeOf(context).height < 780 ? 0.06 : 0.055;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        onExtentChanged?.call(notification.extent);
        return false;
      },
      child: DraggableScrollableSheet(
        controller: controller,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        snap: true,
        snapSizes: snapSizes,
        builder: (context, scrollController) {
          return CommonBottomSheet(
            showDefaultHeader: false,
            maxHeightRatio: 1,
            padding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            backgroundColor:
                isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                const SliverPersistentHeader(
                  pinned: true,
                  delegate: _MapBottomSheetHandleHeader(),
                ),
                ...slivers,
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MapBottomSheetHandleHeader extends SliverPersistentHeaderDelegate {
  const _MapBottomSheetHandleHeader();

  @override
  double get minExtent => 22;

  @override
  double get maxExtent => 22;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: context.surfaceColor,
      child: const _MapBottomSheetHandle(),
    );
  }

  @override
  bool shouldRebuild(covariant _MapBottomSheetHandleHeader oldDelegate) =>
      false;
}

class _MapBottomSheetHandle extends StatelessWidget {
  const _MapBottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
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
}
