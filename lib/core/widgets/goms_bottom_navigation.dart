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

    // ponytail: SafeArea(padding)는 상위에서 소비되거나 기기/OS별로 0으로
    // 리포팅되면 안 밀어올려 일부 기기에서 시스템 네비바와 겹쳤다. 소비/편차의
    // 영향을 안 받는 물리 인셋 viewPadding을 직접 더해 기기 편차를 없앤다.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Theme(
      data: noTouchEffectTheme,
      child: Container(
        padding: EdgeInsets.fromLTRB(52, 24, 52, 24 + bottomInset),
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
