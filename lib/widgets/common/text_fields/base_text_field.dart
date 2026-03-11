import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    final theme = Theme.of(context);
    final base =
        const InputDecoration().applyDefaults(theme.inputDecorationTheme);

    InputBorder? errBorder() => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.negative, width: 1),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          enabled: enabled,
          readOnly: readOnly,
          autofocus: autofocus,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          validator: validator,
          cursorColor: hasError ? AppColors.negative : null,
          style: hasError
              ? AppTextStyles.text2.withColor(AppColors.negative)
              : null,
          decoration: base.copyWith(
            hintText: hintText,
            labelText: labelText,
            errorText: null,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,

            // ✅ 테마 filled 유지 + 필요할 때만 override
            filled: fillColor != null ? true : base.filled,
            fillColor: fillColor ?? base.fillColor,

            contentPadding: contentPadding ?? base.contentPadding,

            // ✅ 테마 border류 유지 + 필요할 때만 override
            border: border ?? base.border,
            enabledBorder:
                hasError ? errBorder() : (enabledBorder ?? base.enabledBorder),
            focusedBorder:
                hasError ? errBorder() : (focusedBorder ?? base.focusedBorder),
            disabledBorder: disabledBorder ?? base.disabledBorder,
            errorBorder: errorBorder ?? base.errorBorder,
            focusedErrorBorder: focusedErrorBorder ?? base.focusedErrorBorder,
          ),
        ),
        if (hasError)
          Padding(
            padding:
                const EdgeInsets.only(top: AppSpacing.s4, right: AppSpacing.s4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                errorText!,
                style: AppTextStyles.text3.withColor(AppColors.negative),
              ),
            ),
          ),
      ],
    );
  }
}
