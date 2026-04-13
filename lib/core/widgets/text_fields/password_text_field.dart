import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/widgets/text_fields/base_text_field.dart';
import 'package:goms/core/widgets/text_fields/providers/password_visibility_provider.dart';

/// 비밀번호 입력 텍스트 필드 (보기/숨기기 기능 포함)
class PasswordTextField extends ConsumerWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.providerKey,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final Object? providerKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key =
        providerKey ?? controller ?? this.key ?? hintText ?? runtimeType;
    final obscureText = ref.watch(passwordVisibilityProvider(key));

    return BaseTextField(
      controller: controller,
      hintText: hintText,
      errorText: errorText,
      obscureText: obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      suffixIcon: IconButton(
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 24,
          color: context.sub2Color,
        ),
        onPressed: () {
          ref.read(passwordVisibilityProvider(key).notifier).state =
              !obscureText;
        },
      ),
    );
  }
}
