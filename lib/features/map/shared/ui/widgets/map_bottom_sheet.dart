import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
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
  });

  final bool isLight;
  final List<Widget> slivers;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final List<double> snapSizes;
  final ValueChanged<double>? onExtentChanged;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        onExtentChanged?.call(notification.extent);
        return false;
      },
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        snap: true,
        snapSizes: snapSizes,
        builder: (context, controller) {
          return CommonBottomSheet(
            showDefaultHeader: false,
            maxHeightRatio: 1,
            padding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            backgroundColor:
                isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
            child: CustomScrollView(
              controller: controller,
              slivers: [
                const SliverToBoxAdapter(child: _MapBottomSheetHandle()),
                ...slivers,
              ],
            ),
          );
        },
      ),
    );
  }
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
