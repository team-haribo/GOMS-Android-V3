import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

class ArrivalDepartureButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final TextStyle? textStyle;

  const ArrivalDepartureButton({
    super.key,
    required this.buttonText,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
    this.width,
    this.height = 33,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 89,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          buttonText,
          style:
              (textStyle ?? AppTextStyles.caption1).copyWith(color: textColor),
        ),
      ),
    );
  }
}
