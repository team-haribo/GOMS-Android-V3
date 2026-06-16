import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

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
    final theme = Theme.of(context);
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor!;
    final unselectedColor = theme.bottomNavigationBarTheme.unselectedItemColor!;
    final noTouchEffectTheme = theme.copyWith(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );

    return Theme(
      data: noTouchEffectTheme,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => onTap(0),
              child: AppIcons.map(width: 24, height: 24, color: currentIndex == 0 ? selectedColor : unselectedColor),
            ),
            GestureDetector(
              onTap: () => onTap(1),
              child: AppIcons.home(width: 24, height: 24, color: currentIndex == 1 ? selectedColor : unselectedColor),
            ),
            GestureDetector(
              onTap: () => onTap(2),
              child: AppIcons.user(width: 24, height: 24, color: currentIndex == 2 ? selectedColor : unselectedColor),
            ),
          ],
        ),
      ),
    );
  }
}
