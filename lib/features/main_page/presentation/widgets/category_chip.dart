import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class CategoryChip extends StatefulWidget {
  final String category;

  const CategoryChip({super.key, required this.category});

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: () => setState(() => isSelected = !isSelected),
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.admin.withOpacity(0.25)
              : (isLight ? AppColors.button : AppColors.buttonDark),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.category,
          style: AppTextStyles.text2.copyWith(
            color: isSelected
                ? AppColors.admin
                : (isLight ? AppColors.sub2 : AppColors.sub2Dark),
          ),
        ),
      ),
    );
  }
}
