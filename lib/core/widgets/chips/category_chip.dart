import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms_design_system/goms_design_system.dart';

final _categoryChipSelectionProvider = NotifierProvider.autoDispose
    .family<_CategoryChipSelectionNotifier, bool, Object>(
  _CategoryChipSelectionNotifier.new,
);

class _CategoryChipSelectionNotifier extends Notifier<bool> {
  _CategoryChipSelectionNotifier(this.key);

  final Object key;

  @override
  bool build() => false;

  void setSelected(bool value) => state = value;
}

class CategoryChip extends ConsumerStatefulWidget {
  final String category;
  final bool? selected;
  final ValueChanged<bool>? onChanged;
  final Color? textColor;

  const CategoryChip({
    super.key,
    required this.category,
    this.selected,
    this.onChanged,
    this.textColor,
  });

  @override
  ConsumerState<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends ConsumerState<CategoryChip> {
  late final Object _providerKey;

  @override
  void initState() {
    super.initState();
    _providerKey = Object();
  }

  @override
  Widget build(BuildContext context) {
    final isControlled = widget.selected != null;
    final selected = isControlled
        ? widget.selected!
        : ref.watch(_categoryChipSelectionProvider(_providerKey));

    return GestureDetector(
      onTap: () {
        final next = !selected;
        if (isControlled) {
          widget.onChanged?.call(next);
          return;
        }
        ref
            .read(_categoryChipSelectionProvider(_providerKey).notifier)
            .setSelected(next);
        widget.onChanged?.call(next);
      },
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.admin.withValues(alpha: 0.25)
              : (context.buttonColor),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.category,
          style: AppTextStyles.text2.copyWith(
            color: selected
                ? AppColors.admin
                : (widget.textColor ?? context.sub2Color),
          ),
        ),
      ),
    );
  }
}
