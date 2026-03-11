import 'package:flutter/material.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
class PlaceContainer extends StatefulWidget {
  final String placeName;
  final String category;
  final String address;
  final int review;
  final int recommended;

  const PlaceContainer({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
  });

  @override
  State<PlaceContainer> createState() => _PlaceContainerState();
}

class _PlaceContainerState extends State<PlaceContainer> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
        height: 93,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLight ? AppColors.bgMapContainer : AppColors.bgMapContainerDark,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.placeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.text2.copyWith(
                              color: isLight ? AppColors.mainText : AppColors.mainTextDark,
                            ),
                          ),
                          AppGap.h4,
                          Text(
                            widget.category,
                            style: AppTextStyles.caption2.copyWith(
                              color: isLight ? AppColors.sub2 : AppColors.gray3,
                            ),
                          ),
                        ],
                      ),
                      AppGap.v4,
                      Text(
                        widget.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption2.copyWith(
                          color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                        ),
                      ),
                      AppGap.v4,
                      Row(
                        children: [
                          Text(
                            '학생 후기',
                            style: AppTextStyles.caption2.copyWith(
                              color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                            ),
                          ),
                          AppGap.h4,
                          Text(
                            widget.review >= 10
                                ? '${widget.review}+'
                                : widget.review.toString(),
                            style: AppTextStyles.caption1.copyWith(
                              color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                            ),
                          ),
                          AppGap.h4,
                          Text(
                            '|',
                            style: AppTextStyles.caption2.copyWith(
                              color:isLight ? AppColors.sub2 : AppColors.sub2Dark,
                            ),
                          ),
                          AppGap.h4,
                          Text(
                            '추천',
                            style: AppTextStyles.caption2.copyWith(
                              color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                            ),
                          ),
                          AppGap.h4,
                          Text(
                            widget.recommended >= 10
                                ? '${widget.recommended}+'
                                : widget.recommended.toString(),
                            style: AppTextStyles.caption1.copyWith(
                              color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.s8),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      // TODO: 상태관리 변경
                      isLiked = !isLiked;
                    });
                  },
                  icon: isLiked
                      ? AppIcons.heartFilled(width: 24, height: 24)
                      : AppIcons.heart(width: 24, height: 24),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
