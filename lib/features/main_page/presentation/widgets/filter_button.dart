import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/main_page/presentation/widgets/filter_bottomsheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),),
          backgroundColor:
              isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
          builder: (context) => FractionallySizedBox(heightFactor: 0.71, child: const FilterBottomSheet(),)
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 텍스트버튼 크기 딱 맞추기

      ),
      child: Text(
        '필터',
        style: AppTextStyles.caption2.copyWith(
          color: AppColors.admin,
        ),
      ),
    );
  }
}
