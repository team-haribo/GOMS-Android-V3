import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';

/// 리스트에서 하나를 고르는 머터리얼 바텀싯 (기존 쿠퍼티노 액션싯 대체).
class SelectionBottomSheet<T> extends StatelessWidget {
  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.selected,
  });

  final String title;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T> onSelected;
  final T? selected;

  static Future<void> show<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T> onSelected,
    T? selected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => SelectionBottomSheet<T>(
        title: title,
        items: items,
        itemLabel: itemLabel,
        onSelected: onSelected,
        selected: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: title,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 42),
      headerBottomSpacing: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i != 0) const Divider(height: 1),
            _SelectionRow(
              label: itemLabel(items[i]),
              selected: items[i] == selected,
              onTap: () {
                Navigator.pop(context);
                onSelected(items[i]);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.text2.withColor(context.mainTextColor),
              ),
            ),
            if (selected)
              AppIcons.check(width: 20, height: 20, color: context.mainTextColor),
          ],
        ),
      ),
    );
  }
}
