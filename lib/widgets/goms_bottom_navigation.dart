import 'package:flutter/material.dart';
import 'package:goms/core/theme/icons/app_icons.dart';

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

    return SizedBox(
      height: 84,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: AppIcons.map(
              width: 24,
              height: 24,
              color: currentIndex == 0 ? selectedColor : unselectedColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.home(
              width: 24,
              height: 24,
              color: currentIndex == 1 ? selectedColor : unselectedColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.user(
              width: 24,
              height: 24,
              color: currentIndex == 2 ? selectedColor : unselectedColor,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
