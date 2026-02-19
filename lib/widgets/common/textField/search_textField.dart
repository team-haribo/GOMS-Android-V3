import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_setting/widgets/common/textField/base_textField.dart';
import 'package:project_setting/core/constants/icon.dart';
import 'package:project_setting/core/theme/app_colors.dart';

/// 검색 텍스트 필드
class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    this.controller,
    this.hintText = '지번, 지점 이름을 입력해주세요',
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onBackPressed,
    this.showBackButton = false,
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

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateClearButton);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateClearButton);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateClearButton() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final iconColor = isDark ? AppColors.sub2Dark : AppColors.sub2;

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
      prefixIcon: widget.showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, size: 20, color: iconColor),
              onPressed: widget.onBackPressed,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgPicture.asset(
                AppIcons.logoSmall,
                width: 20,
                height: 20,
              ),
            ),
      suffixIcon: _showClearButton
          ? IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
                color: hasError ? AppColors.negative : iconColor,
              ),
              onPressed: _clearText,
            )
          : Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.search, size: 20, color: iconColor),
            ),
    );
  }
}
