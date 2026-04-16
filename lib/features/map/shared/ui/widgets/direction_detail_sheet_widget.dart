import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/direction/ui/models/direction_state.dart';

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
    final sheetBg =
        dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;
    final textColor = dark ? AppColors.mainTextDark : AppColors.mainText;
    final subColor = dark ? AppColors.sub1Dark : AppColors.sub1;
    final dividerColor = dark ? AppColors.buttonDark : AppColors.button;
    final shadowColor = (dark ? AppColors.backgroundDark : AppColors.background)
        .withValues(alpha: 0.22);

    return Container(
      height: context.responsive(compact: 360, normal: 460, tablet: 520),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          AppGap.v12,
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: subColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 16, 8),
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
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
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
