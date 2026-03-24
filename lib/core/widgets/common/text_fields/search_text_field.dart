import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/widgets/common/text_fields/base_text_field.dart';
import 'package:goms/core/widgets/common/text_fields/viewmodels/search_text_field_provider.dart';

/// 검색 텍스트 필드
class SearchTextField extends ConsumerStatefulWidget {
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
  ConsumerState<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends ConsumerState<SearchTextField> {
  late TextEditingController _controller;

  Object get _providerKey =>
      widget.controller ?? widget.key ?? widget.hintText ?? widget.runtimeType;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateClearButton);
    _updateClearButton();
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
    ref.read(searchTextHasValueProvider(_providerKey).notifier).state =
        _controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = context.sub2Color;
    final showClearButton = ref.watch(searchTextHasValueProvider(_providerKey));

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
                  icon:
                    AppIcons.back(width: 24, height: 24, color: iconColor),
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

