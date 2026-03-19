import 'package:flutter/material.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class SearchProfileList extends StatelessWidget {
  final String name;
  final int grade;
  final String major;

  const SearchProfileList({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.backgroundColor,
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              radius: 26,
              child: AppIcons.profileCircle(),
            ),
          ),
          AppGap.v4,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: context.sub1Color,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    '$grade기| $major',
                    style: AppTextStyles.caption2.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                  AppGap.h4,
                  SizedBox(
                    height: 8,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: context.buttonColor,
                    ),
                  ),
                  AppGap.h4,
                  Text(
                    '10:31에 외출',
                    style: AppTextStyles.caption2.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
