import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

class ConfirmButton extends StatelessWidget {
  /// 확인 버튼 텍스트
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
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? context.responsive(compact: 44, normal: 48, tablet: 52),
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
            : Text(text, style: AppTextStyles.text2),
      ),
    );
  }
}
