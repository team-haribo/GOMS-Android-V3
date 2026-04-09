import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

final _categoryChipSelectionProvider =
    StateProvider.autoDispose.family<bool, Object>((ref, key) => false);

class CategoryChip extends ConsumerStatefulWidget {
  final String category;
  final bool? selected;
  final ValueChanged<bool>? onChanged;

  const CategoryChip({
    super.key,
    required this.category,
    this.selected,
    this.onChanged,
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
        ref.read(_categoryChipSelectionProvider(_providerKey).notifier).state =
            next;
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
            color: selected ? AppColors.admin : (context.sub2Color),
          ),
        ),
      ),
    );
  }
}
