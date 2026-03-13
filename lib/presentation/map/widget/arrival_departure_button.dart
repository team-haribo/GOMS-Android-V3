import 'package:flutter/material.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class ArrivalDepartureButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const ArrivalDepartureButton({
    super.key,
    required this.buttonText,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 89,
      height: 33,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          buttonText,
          style: AppTextStyles.caption1.copyWith(color: textColor),
        ),
      ),
    );
  }
}
