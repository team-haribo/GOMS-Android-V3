import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/widgets/common/text_fields/base_text_field.dart';

/// 검색 텍스트 필드
class SearchStudentField extends StatefulWidget {
  const SearchStudentField({
    super.key,
    this.controller,
    this.hintText = '학생 검색',
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onBackPressed,
    this.showBackButton = false,
    this.showLogo = true,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final bool showLogo;

  @override
  State<SearchStudentField> createState() => _SearchStudentFieldState();
}

class _SearchStudentFieldState extends State<SearchStudentField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseTextField(
      controller: _controller,
      hintText: widget.hintText,
      errorText: widget.errorText,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.search, size: 24, color: isDark ? AppColors.sub2Dark : AppColors.sub2),
      ),
    );
  }
}
