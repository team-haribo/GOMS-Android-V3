import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/direction/ui/models/direction_state.dart';

class DirectionRouteCarousel extends StatelessWidget {
  final ScrollController scrollController;
  final List<RouteOption> routeOptions;
  final int selectedIndex;
  final bool dark;
  final ValueChanged<int> onTap;

  const DirectionRouteCarousel({
    super.key,
    required this.scrollController,
    required this.routeOptions,
    required this.selectedIndex,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (routeOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: context.responsive(compact: 152, normal: 168, tablet: 180),
      child: ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          vertical: context.responsive(compact: 16, normal: 24, tablet: 28),
          horizontal: context.responsive(compact: 8, normal: 12, tablet: 16),
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final option = routeOptions[index];
          return SizedBox(
            width: context.responsive(compact: 184, normal: 208, tablet: 236),
            child: _RouteOptionCard(
              option: option,
              isSelected: selectedIndex == index,
              dark: dark,
              onTap: () => onTap(index),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: routeOptions.length,
      ),
    );
  }
}

class _RouteOptionCard extends StatelessWidget {
  final RouteOption option;
  final bool isSelected;
  final bool dark;
  final VoidCallback onTap;

  const _RouteOptionCard({
    required this.option,
    required this.isSelected,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.bgSurfaceDark : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.mainColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  option.label,
                  style: AppTextStyles.text1.copyWith(
                    color: dark ? AppColors.sub1Dark : AppColors.sub1,
                  ),
                ),
                AppGap.h4,
                AppIcons.rightArrow(),
              ],
            ),
            AppGap.v4,
            Text(
              '${option.minutes}분',
              style: AppTextStyles.title3.copyWith(
                color: dark ? AppColors.mainTextDark : AppColors.mainText,
                fontSize: 18,
              ),
            ),
            AppGap.v4,
            Text(
              '${option.meters}m',
              style: AppTextStyles.text2.copyWith(
                color: dark ? AppColors.sub2Dark : AppColors.sub2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
