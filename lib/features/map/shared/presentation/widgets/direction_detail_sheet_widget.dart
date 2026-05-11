import 'package:flutter/material.dart';
import 'package:goms/features/map/direction/presentation/models/direction_state.dart';
import 'package:goms/features/map/shared/presentation/widgets/map_bottom_sheet.dart';
import 'package:goms_design_system/goms_design_system.dart';

class DirectionDetailSheet extends StatelessWidget {
  final RouteOption option;
  final String departureName;
  final String destinationName;
  final bool dark;
  final VoidCallback onClose;

  const DirectionDetailSheet({
    super.key,
    required this.option,
    required this.departureName,
    required this.destinationName,
    required this.dark,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final collapsedSheetSize = MapBottomSheet.handleOnlyMinSize(context);
    final initialSheetSize = context.isTabletLayout
        ? 0.4
        : (context.screenHeight < 780 ? 0.34 : 0.3);
    final maxSheetSize = context.isTabletLayout ? 0.8 : 0.86;
    final dividerColor = dark ? AppColors.buttonDark : AppColors.button;

    return MapBottomSheet(
      isLight: !dark,
      initialChildSize: initialSheetSize,
      minChildSize: collapsedSheetSize,
      maxChildSize: maxSheetSize,
      snapSizes: <double>[
        collapsedSheetSize,
        initialSheetSize,
        context.isTabletLayout ? 0.6 : 0.58,
        maxSheetSize,
      ],
      slivers: [
        SliverToBoxAdapter(
          child: _RouteSummarySection(
            option: option,
            departureName: departureName,
            destinationName: destinationName,
            dark: dark,
            onClose: onClose,
          ),
        ),
        SliverList.separated(
          itemBuilder: (_, index) => _DirectionStepTile(
            step: option.steps[index],
            dark: dark,
          ),
          separatorBuilder: (_, __) => Divider(
            color: dividerColor,
            height: 1,
          ),
          itemCount: option.steps.length,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _RouteSummarySection extends StatelessWidget {
  const _RouteSummarySection({
    required this.option,
    required this.departureName,
    required this.destinationName,
    required this.dark,
    required this.onClose,
  });

  final RouteOption option;
  final String departureName;
  final String destinationName;
  final bool dark;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? AppColors.mainTextDark : AppColors.mainText;
    final subColor = dark ? AppColors.sub1Dark : AppColors.sub1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${departureName.isEmpty ? '학교' : departureName} -> $destinationName',
                  style: AppTextStyles.text2.copyWith(color: subColor),
                ),
                AppGap.v8,
                Text(
                  '${option.label} 경로',
                  style: AppTextStyles.title3.copyWith(color: textColor),
                ),
                AppGap.v12,
                Text(
                  '${option.minutes}분',
                  style: AppTextStyles.title1.copyWith(color: textColor),
                ),
                AppGap.v4,
                Text(
                  '${option.meters}m',
                  style: AppTextStyles.text3.copyWith(color: subColor),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close_rounded,
              color: subColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionStepTile extends StatelessWidget {
  final RouteStep step;
  final bool dark;

  const _DirectionStepTile({required this.step, required this.dark});

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? AppColors.mainTextDark : AppColors.mainText;
    final descColor = dark ? AppColors.sub1Dark : AppColors.sub1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Icon(
              _iconForStep(step),
              color: AppColors.mainColor,
              size: 30,
            ),
          ),
          AppGap.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.text1.copyWith(color: textColor),
                ),
                AppGap.v4,
                Text(
                  step.description,
                  style: AppTextStyles.text3.copyWith(color: descColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForStep(RouteStep step) {
    if (step.type == 100) {
      return Icons.location_on_outlined;
    }
    if (step.type == 101) {
      return Icons.flag_outlined;
    }
    if (step.title.contains('좌회전')) {
      return Icons.turn_left_rounded;
    }
    if (step.title.contains('우회전')) {
      return Icons.turn_right_rounded;
    }
    if (step.title.contains('유턴')) {
      return Icons.u_turn_left_rounded;
    }
    return Icons.straight_rounded;
  }
}
