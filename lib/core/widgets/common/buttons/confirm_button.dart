import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class ConfirmButton extends StatelessWidget {
  /// 踰꾪듉 ?띿뒪??
  final String text;

  /// 踰꾪듉 ?대┃ 肄쒕갚
  final VoidCallback? onPressed;

  /// 踰꾪듉 ?덈퉬 (湲곕낯媛? double.infinity)
  final double? width;

  /// 踰꾪듉 ?믪씠 (湲곕낯媛? 44)
  final double? height;

  /// 濡쒕뵫 ?곹깭
  final bool isLoading;

  const ConfirmButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? context.space(48),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return context.buttonColor;
            }
            return AppColors.mainColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.sub2;
            }
            return Colors.white;
          }),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text, style: context.appTypography.text2),
      ),
    );
  }
}
