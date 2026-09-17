import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

class DateButton extends StatelessWidget {
  const DateButton({
    super.key,
    this.label = '날짜',
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: AppTextStyles.text2.copyWith(
          color: AppColors.admin,
        ),
      ),
    );
  }
}
