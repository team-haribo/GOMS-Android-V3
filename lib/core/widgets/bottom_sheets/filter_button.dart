import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.bottomSheetBuilder,
    this.textColor,
  });

  final WidgetBuilder bottomSheetBuilder;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          backgroundColor: context.surfaceColor,
          builder: bottomSheetBuilder,
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        '필터',
        style: AppTextStyles.caption2.copyWith(
          color: textColor ?? AppColors.admin,
        ),
      ),
    );
  }
}
