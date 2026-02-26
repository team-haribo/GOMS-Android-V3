import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';

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
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            errorText: null, // errorText는 별도로 표시
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            filled: fillColor != null,
            fillColor: fillColor,
            contentPadding: contentPadding,
            border: border,
            enabledBorder: hasError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.negative,
                      width: 1,
                    ),
                  )
                : enabledBorder,
            focusedBorder: hasError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.negative,
                      width: 1,
                    ),
                  )
                : focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: focusedErrorBorder,
            disabledBorder: disabledBorder,
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
