import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/text_fields/base_text_field.dart';

/// 이메일 입력 텍스트 필드
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.suffixText = '@gsm.hs.kr',
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final String? suffixText;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return BaseTextField(
      controller: controller,
      hintText: hintText,
      errorText: errorText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      suffixIcon: suffixText != null
          ? Padding(
              padding: const EdgeInsets.only(
                right: AppSpacing.s16,
                top: AppSpacing.s14,
              ),
              child: Text(
                suffixText!,
                style: hasError
                    ? AppTextStyles.text3.withColor(AppColors.negative)
                    : AppTextStyles.text3.withColor(context.sub2Color),
              ),
            )
          : null,
    );
  }
}
