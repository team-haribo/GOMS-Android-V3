import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';

class GomsBottomNavigation extends StatelessWidget {
  final int currentIndex;

  final ValueChanged<int> onTap;

  const GomsBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    const selectedColor = AppColors.sub2;
    final unselectedColor = isDarkMode ? AppColors.sub2Dark : AppColors.button;
    final backgroundColor = isDarkMode
        ? AppColors.bgSurfaceDark
        : AppColors.bgSurface;

    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: SizedBox(
        height: 84,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: AppIcons.map(
                width: 24,
                height: 24,
                color: currentIndex == 0 ? selectedColor : unselectedColor,
              ),
              index: 0,
            ),
            _buildNavItem(
              icon: AppIcons.home(
                width: 24,
                height: 24,
                color: currentIndex == 1 ? selectedColor : unselectedColor,
              ),
              index: 1,
            ),
            _buildNavItem(
              icon: AppIcons.user(
                width: 24,
                height: 24,
                color: currentIndex == 2 ? selectedColor : unselectedColor,
              ),
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required Widget icon, required int index}) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: SizedBox(
          height: double.infinity,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
