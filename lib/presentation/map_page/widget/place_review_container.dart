import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/core/theme/app_layout.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class PlaceReviewContainer extends StatefulWidget {
  final String placeName;
  final String category;
  final String address;
  final String reviewDetailContent;

  const PlaceReviewContainer({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.reviewDetailContent,
  });

  @override
  State<PlaceReviewContainer> createState() => _PlaceReviewContainerState();
}

class _PlaceReviewContainerState extends State<PlaceReviewContainer> {
  final bool isLiked = false;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 93,
      width: 327,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.sub2Dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          widget.reviewDetailContent.length > 10
                              ? '${widget.reviewDetailContent.substring(0, 10)}···'
                              : widget.reviewDetailContent,
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.sub2Dark,
                          ),
                        ),
                        AppGap.h4,
                        Text(
                          '작성일: ${DateFormat('yy.MM.dd').format(DateTime.now())}',
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
              child: IconButton(onPressed: () {}, icon: AppIcons.bin()),
            ),
          ],
        ),
      ),
    );
  }
}
