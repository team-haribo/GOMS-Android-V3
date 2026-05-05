import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

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
