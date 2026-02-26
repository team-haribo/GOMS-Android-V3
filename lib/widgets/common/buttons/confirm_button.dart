import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';

class ConfirmButton extends StatelessWidget {
  /// 버튼 텍스트
  final String text;

  /// 버튼 클릭 콜백
  final VoidCallback? onPressed;

  /// 버튼 너비 (기본값: double.infinity)
  final double? width;

  /// 버튼 높이 (기본값: 44)
  final double? height;

  /// 로딩 상태
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              // disabled: button 색상 (light/dark 모드 모두)
              return isDarkMode ? AppColors.buttonDark : AppColors.button;
            }
            return AppColors.mainColor; // default: mainColor
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
            : Text(text, style: AppTextStyles.text2),
      ),
    );
  }
}
