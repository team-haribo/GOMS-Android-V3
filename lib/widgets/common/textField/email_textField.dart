import 'package:flutter/material.dart';
import 'package:project_setting/widgets/common/textField/base_textField.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              padding: const EdgeInsets.only(right: 16, top: 14),
              child: Text(
                suffixText!,
                style: hasError
                    ? AppTextStyles.text3.withColor(AppColors.negative)
                    : AppTextStyles.text3.withColor(
                        isDark ? AppColors.sub2Dark : AppColors.sub2,
                      ),
              ),
            )
          : null,
    );
  }
}
