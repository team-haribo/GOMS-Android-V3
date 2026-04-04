import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/home/shared/presentation/widgets/filter_bottomsheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    this.bottomSheetBuilder,
  });

  final WidgetBuilder? bottomSheetBuilder;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          backgroundColor: context.surfaceColor,
          builder: (context) =>
              bottomSheetBuilder?.call(context) ?? const FilterBottomSheet(),
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
