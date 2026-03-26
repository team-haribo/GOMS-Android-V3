import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class DateButton extends StatelessWidget {
  const DateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        '날짜',
        style: AppTextStyles.text2.copyWith(
          color: AppColors.admin,
        ),
      ),
    );
  }
}

class _CalendarBottomSheet extends StatefulWidget {

  @override
  State<_CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<_CalendarBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}