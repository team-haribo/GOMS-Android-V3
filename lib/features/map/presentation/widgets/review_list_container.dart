import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/goms_dialog.dart';
import 'package:intl/intl.dart';

class ReviewListContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String reviewDetailContent;
  final DateTime createdAt;
  final bool isMine;

  const ReviewListContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.reviewDetailContent,
    required this.createdAt,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme
        .of(context)
        .brightness == Brightness.light;
    return Container(
      height: 83,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
        border: Border(
          bottom: BorderSide(
            color: isLight ? AppColors.button : AppColors.buttonDark,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppIcons.profileCircle(
            width: 48,
            height: 48,
          ),
          AppGap.h16,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: AppTextStyles.text1.copyWith(
                      color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
                    ),
                  ),
                  AppGap.h4,
                  Text(
                    '$grade기 | $major',
                    style: AppTextStyles.caption2.copyWith(
                      color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                    ),
                  ),
                ],
              ),
              AppGap.v4,
              Text(
                reviewDetailContent,
                style: AppTextStyles.caption2.copyWith(
                  color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                ),
              ),
              AppGap.v4,
              Text(
              DateFormat('yy.MM.dd').format(createdAt),
                style: AppTextStyles.caption3.copyWith(
                  color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                ),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: isMine
                ? IconButton(
              onPressed: () {
                GomsDialog.reviewRemove(
                    context: context,
                    title: '후기 삭제',
                    content: '\n 정말 후기를 삭제하시겠습니까?',);
              },
              icon: AppIcons.bin(
                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
              ),
            )
                : IconButton(
              onPressed: () {
                GomsDialog.reviewReport(context: context,
                    title: '후기 신고',
                    content: '이 후기를 신고하시겠습니까?\n신고 내용은 운영팀의 검토 후 처리됩니다.',);
              },
              icon: AppIcons.report(
                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

