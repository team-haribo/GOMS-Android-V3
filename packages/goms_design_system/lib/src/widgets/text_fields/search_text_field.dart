import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

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
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  late bool _showClearButton;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _showClearButton = _controller.text.isNotEmpty;
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
    final hasValue = _controller.text.isNotEmpty;
    if (_showClearButton == hasValue || !mounted) {
      return;
    }

    setState(() {
      _showClearButton = hasValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = context.sub2Color;
    final showClearButton = _showClearButton;

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
      prefixIcon: widget.showLogo
          ? (showClearButton
              ? IconButton(
                  icon: AppIcons.back(width: 24, height: 24, color: iconColor),
                  onPressed: widget.onBackPressed,
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                  child: AppIcons.logoSmall(),
                ))
          : null,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Icon(Icons.search, size: 24, color: iconColor),
      ),
    );
  }
}
