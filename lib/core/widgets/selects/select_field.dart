import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/bottom_sheets/selection_bottom_sheet.dart';

class SelectField<T> extends StatelessWidget {
  const SelectField({
    super.key,
    required this.hintText,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
    this.enabled = true,
  });

  final String hintText;
  final List<T> items;
  final String Function(T) itemLabel;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _showPicker(context) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.surfaceColor,
        ),
        child: Text(
          value != null ? itemLabel(value as T) : hintText,
          style: value != null
              ? AppTextStyles.text2.withColor(
                  enabled ? context.mainTextColor : context.sub2Color,
                )
              : AppTextStyles.text2.withColor(context.sub2Color),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    SelectionBottomSheet.show<T>(
      context,
      title: hintText,
      items: items,
      itemLabel: itemLabel,
      selected: value,
      onSelected: (item) => onChanged?.call(item),
    );
  }
}
