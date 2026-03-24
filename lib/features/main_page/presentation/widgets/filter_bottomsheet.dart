import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/main_page/presentation/widgets/category_chip.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGap.v24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '필터',
                  style: AppTextStyles.title3.copyWith(
                    color: isLight ? Colors.black : Colors.white,
                  ),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: AppIcons.cancel()),
              ],
            ),
            AppGap.v24,
            Text(
              '역할',
              style: AppTextStyles.title3.copyWith(
                color: isLight ? Colors.black : Colors.white,
              ),
            ),
            AppGap.v12,
            const Row(
              children: [
                Expanded(child: CategoryChip(category: '학생')),
                AppGap.h8,
                Expanded(child: CategoryChip(category: '학생회')),
                AppGap.h8,
                Expanded(child: CategoryChip(category: '외출 금지')),
              ],
            ),
            AppGap.v24,
            Text('학년', style: AppTextStyles.title3.copyWith(color: isLight ? Colors.black : Colors.white),),
            AppGap.v12,
            const Row(children: [
              Expanded(child: CategoryChip(category: '1학년')),
              AppGap.h8,
              Expanded(child: CategoryChip(category: '2학년')),
              AppGap.h8,
              Expanded(child: CategoryChip(category: '3학년')),
            ],),
            AppGap.v24,
            Text(
              '성별',
              style: AppTextStyles.title3.copyWith(
                color: isLight ? Colors.black : Colors.white,
              ),
            ),
            AppGap.v12,
            const Row(
              children: [
                Expanded(child: CategoryChip(category: '남성')),
                AppGap.h8,
                Expanded(child: CategoryChip(category: '여성')),
              ],
            ),
            AppGap.v24,
            Text(
              '학과',
              style: AppTextStyles.title3.copyWith(
                color: isLight ? Colors.black : Colors.white,
              ),
            ),
            AppGap.v12,
            const Row(
              children: [
                Expanded(child: CategoryChip(category: 'sw')),
                AppGap.h8,
                Expanded(child: CategoryChip(category: 'iot')),
                AppGap.h8,
                Expanded(child: CategoryChip(category: 'ai')),
              ],
            ),
            AppGap.v24,
            GestureDetector(
              onTap: () {
              },
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.negative.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '필터 초기화',
                  style: AppTextStyles.text2.copyWith(color: AppColors.negative,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
