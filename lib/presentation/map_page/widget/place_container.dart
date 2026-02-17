import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';

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
    return Container(
      height: 93,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgMapContainerDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                          style: AppTextStyles.text2.copyWith(
                            color: AppColors.mainTextDark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.category,
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.gray3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.address,
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.sub2Dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '학생 후기',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.sub2Dark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.review >= 10
                              ? '${widget.review}+'
                              : widget.review.toString(),
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.sub2Dark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '|',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.sub2Dark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '추천',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.sub2Dark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.recommended >= 10
                              ? '${widget.recommended}+'
                              : widget.recommended.toString(),
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
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                icon: isLiked
                    ? AppIcons.heartFilledIcon(width: 24, height: 24)
                    : AppIcons.heartIcon(width: 24, height: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
