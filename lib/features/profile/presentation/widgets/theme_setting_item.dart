import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goms_design_system/goms_design_system.dart';

/// 앱 테마 설정 항목 (Figma 569-10492)
///
/// 헤더를 누르면 아래로 선택지 목록이 펼쳐지는 아코디언이다.
class ThemeSettingItem extends StatefulWidget {
  const ThemeSettingItem({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AppThemeOption selected;
  final ValueChanged<AppThemeOption> onSelected;

  @override
  State<ThemeSettingItem> createState() => _ThemeSettingItemState();
}

class _ThemeSettingItemState extends State<ThemeSettingItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '앱 테마 설정',
          style: AppTextStyles.text1.withColor(context.mainTextColor),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.selected.label,
                    style: AppTextStyles.text2.withColor(context.sub1Color),
                  ),
                ),
                RotatedBox(
                  quarterTurns: _expanded ? 2 : 0,
                  child: AppIcons.downArrow(
                    width: 24.r,
                    height: 24.r,
                    color: context.sub1Color,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          SizedBox(height: 8.h),
          _ThemeOptionList(
            selected: widget.selected,
            onSelected: widget.onSelected,
          ),
        ],
      ],
    );
  }
}

/// 펼쳐졌을 때 나오는 선택지 카드 (Figma 569-10540)
class _ThemeOptionList extends StatelessWidget {
  const _ThemeOptionList({required this.selected, required this.onSelected});

  final AppThemeOption selected;
  final ValueChanged<AppThemeOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.buttonColor),
      ),
      child: Column(
        children: [
          for (final (index, option) in AppThemeOption.displayOrder.indexed) ...[
            if (index > 0) Container(height: 1, color: context.buttonColor),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelected(option),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option.label,
                        style: AppTextStyles.text2.withColor(
                          option == selected
                              ? AppColors.mainColor
                              : context.mainTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: option == selected
                          ? AppIcons.checkmark(width: 24.r, height: 24.r)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
