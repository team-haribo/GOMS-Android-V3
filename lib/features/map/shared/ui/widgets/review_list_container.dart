import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';
import 'package:goms/core/widgets/dialogs/review_report_dialog.dart';
import 'package:intl/intl.dart';

class ReviewListContainer extends StatelessWidget {
  final int? reviewId;
  final String name;
  final int grade;
  final String major;
  final String reviewDetailContent;
  final DateTime? createdAt;
  final bool isMine;
  final Future<void> Function(int reviewId)? onDelete;

  const ReviewListContainer({
    super.key,
    this.reviewId,
    required this.name,
    required this.grade,
    required this.major,
    required this.reviewDetailContent,
    required this.createdAt,
    required this.isMine,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: context.buttonColor,
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
                      color: context.sub1Color,
                    ),
                  ),
                  AppGap.h4,
                  Text(
                    '$grade기 | $major',
                    style: AppTextStyles.caption1.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                ],
              ),
              AppGap.v4,
              Text(
                reviewDetailContent,
                style: AppTextStyles.text3.copyWith(
                  color: context.sub2Color,
                ),
              ),
              AppGap.v4,
              Text(
                _formatCreatedAt(createdAt),
                style: AppTextStyles.text3.copyWith(
                  color: context.sub2Color,
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
                      GomsDialog.confirm(
                        title: '후기 삭제',
                        content: '정말 후기를 삭제하시겠습니까?',
                        cancelText: '취소',
                        confirmText: '삭제',
                        isDestructive: true,
                        onConfirm: () async {
                          if (reviewId == null || onDelete == null) {
                            return;
                          }

                          try {
                            await onDelete!(reviewId!);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('후기를 삭제했습니다.'),
                              ),
                            );
                          } catch (_) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('후기 삭제에 실패했습니다.'),
                                backgroundColor: AppColors.negative,
                              ),
                            );
                          }
                        },
                      ).show(context);
                    },
                    icon: AppIcons.bin(
                      color: context.sub2Color,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      reviewReport(
                        context: context,
                        title: '후기 신고',
                        content: '이 후기를 신고하시겠습니까?\n신고 내용은 운영팀의 검토 후 처리됩니다.',
                      );
                    },
                    icon: AppIcons.report(
                      color: context.sub2Color,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatCreatedAt(DateTime? value) {
    if (value == null) {
      return '-';
    }

    return DateFormat('yy.MM.dd').format(value);
  }
}
