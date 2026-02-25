import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/core/theme/app_layout.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';
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
        color: AppColors.bgMapContainerDark,
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
                            color: AppColors.mainTextDark,
                          ),
                        ),
                        AppGap.h4,
                        Text(
                          category,
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.gray3,
                          ),
                        ),
                      ],
                    ),
                    AppGap.v4,
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.sub2Dark,
                      ),
                    ),
                    AppGap.v4,
                    Row(
                      children: [
                        Text(
                          reviewDetailContent.length > 10
                              ? '${reviewDetailContent.substring(0, 10)}···'
                              : reviewDetailContent,
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.sub2Dark,
                          ),
                        ),
                        AppGap.h4,
                        Text(
                          '작성일: ${DateFormat('yy.MM.dd').format(createdAt)}',
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.sub2Dark,
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
