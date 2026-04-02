import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/features/map/shared/presentation/widgets/drag_handle_header.dart';

class MapSheet extends StatelessWidget {
  final bool isLight;
  final ScrollController scrollController;
  final List<Widget> slivers;

  const MapSheet({
    super.key,
    required this.isLight,
    required this.scrollController,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: DragHandleHeader(),
            ),
            ...slivers,
          ],
        ),
      ),
    );
  }
}
