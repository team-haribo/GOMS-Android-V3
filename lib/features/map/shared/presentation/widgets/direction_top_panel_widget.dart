import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

class DirectionTopPanel extends StatelessWidget {
  final String departureName;
  final String destinationName;
  final bool dark;
  final VoidCallback onSwap;
  final ValueChanged<String>? onDepartureSelect;

  const DirectionTopPanel({
    super.key,
    required this.departureName,
    required this.destinationName,
    required this.dark,
    required this.onSwap,
    this.onDepartureSelect,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.horizontalPadding;
    final topPadding = context.responsive(compact: 44, normal: 60, tablet: 64);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: dark ? AppColors.bgSurfaceDark : AppColors.bgSurface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          context.responsive(compact: 16, normal: 20, tablet: 24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: context.responsive(compact: 56, normal: 67, tablet: 72),
              ),
              child: GestureDetector(
                onTap: onSwap,
                behavior: HitTestBehavior.opaque,
                child: AppIcons.crossArrow(),
              ),
            ),
            AppGap.h16,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DirectionFieldBlock(
                    label: '출발',
                    value: departureName,
                    placeholder: '학교',
                    dark: dark,
                    showChevron: true,
                    options: const ['내 위치', '학교'],
                    onOptionSelected: onDepartureSelect,
                  ),
                  AppGap.v4,
                  _DirectionFieldBlock(
                    label: '도착',
                    value: destinationName,
                    placeholder: '',
                    dark: dark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionFieldBlock extends StatefulWidget {
  final String label;
  final String value;
  final String placeholder;
  final bool dark;
  final bool showChevron;
  final List<String>? options;
  final ValueChanged<String>? onOptionSelected;

  const _DirectionFieldBlock({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.dark,
    this.showChevron = false,
    this.options,
    this.onOptionSelected,
  });

  @override
  State<_DirectionFieldBlock> createState() => _DirectionFieldBlockState();
}

class _DirectionFieldBlockState extends State<_DirectionFieldBlock> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _containerKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final containerBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    final containerHeight = containerBox.size.height;
    final bgColor =
        widget.dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;
    final textColor = widget.dark ? AppColors.mainTextDark : AppColors.mainText;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideDropdown,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, containerHeight + 6),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        widget.options!.length,
                        (i) {
                          final option = widget.options![i];
                          final isLast = i == widget.options!.length - 1;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _hideDropdown();
                                  widget.onOptionSelected?.call(option);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: AppTextStyles.text2.copyWith(
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                Divider(
                                  height: 1,
                                  color: widget.dark
                                      ? AppColors.buttonDark
                                      : AppColors.button,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value.trim().isNotEmpty;
    final textColor = widget.dark ? AppColors.sub1Dark : AppColors.sub1;
    final bgColor =
        widget.dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.text3.copyWith(color: textColor),
        ),
        AppGap.v4,
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (widget.options != null && widget.options!.isNotEmpty)
                ? _toggleDropdown
                : null,
            child: Container(
              key: _containerKey,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? widget.value : widget.placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.text3.copyWith(
                        color: hasValue
                            ? textColor
                            : widget.dark
                                ? AppColors.sub2Dark
                                : AppColors.sub2,
                      ),
                    ),
                  ),
                  if (widget.showChevron) AppIcons.downArrow(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
