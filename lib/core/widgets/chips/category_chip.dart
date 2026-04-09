import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class CategoryChip extends StatefulWidget {
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
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final isControlled = widget.selected != null;
    final selected = isControlled ? widget.selected! : isSelected;

    return GestureDetector(
      onTap: () {
        final next = !selected;
        if (isControlled) {
          widget.onChanged?.call(next);
          return;
        }
        setState(() => isSelected = next);
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
