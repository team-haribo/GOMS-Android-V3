import 'package:flutter/material.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:intl/intl.dart';

class PlaceReviewContainer extends StatelessWidget {
  final String placeName;
  final String category;
  final String address;
  final String reviewDetailContent;
  final DateTime createdAt;

  const PlaceReviewContainer({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.reviewDetailContent,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 93,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.mapContainerColor,
        borderRadius: BorderRadius.circular(8),
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
                          placeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.text2.copyWith(
                            color: context.mainTextColor,
                          ),
                        ),
                        AppGap.h4,
                        Text(
                          category,
                          style: AppTextStyles.caption1.copyWith(
                            color: context.isLightMode
                                ? AppColors.sub2
                                : AppColors.gray3,
                          ),
                        ),
                      ],
                    ),
                    AppGap.v4,
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.text3.copyWith(
                        color: context.sub2Color,
                      ),
                    ),
                    AppGap.v4,
                    Row(
                      children: [
                        Text(
                          reviewDetailContent.length > 10
                              ? '${reviewDetailContent.substring(0, 10)}···'
                              : reviewDetailContent,
                          style: AppTextStyles.text3.copyWith(
                            color: context.sub2Color,
                          ),
                        ),
                        AppGap.h4,
                        Text(
                          '작성일: ${DateFormat('yy.MM.dd').format(createdAt)}',
                          style: AppTextStyles.caption1.copyWith(
                            color: context.sub2Color,
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
              child: IconButton(onPressed: () {}, icon: AppIcons.bin()),
            ),
          ],
        ),
      ),
    );
  }
}
