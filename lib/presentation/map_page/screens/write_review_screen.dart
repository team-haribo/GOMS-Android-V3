import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/map_page/models/write_review_state.dart';
import 'package:project_setting/presentation/map_page/viewModels/write_review_provider.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';
import 'package:project_setting/widgets/common/goms_dialog.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String placeName;
  final String category;
  final String address;
  final int review;
  final int recommended;

  const WriteReviewScreen({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
  });

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(writeReviewProvider.notifier).reset();
    });
  }

  void _onNextPressed(WriteReviewNotifier notifier) {
    GomsDialog.confirm(
      title: '후기 등록',
      content: '이 후기를 등록하시겠습니까?',
      cancelText: '취소',
      confirmText: '등록하기',
      onConfirm: () => notifier.submitReview(
        placeName: widget.placeName,
        category: widget.category,
        address: widget.address,
        review: widget.review,
        recommended: widget.recommended,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeReviewProvider);
    final notifier = ref.read(writeReviewProvider.notifier);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isLoading = state.status == WriteReviewStatus.loading;

    ref.listen(writeReviewProvider, (previous, next) async {
      if (!mounted) return;
      if (next.status == WriteReviewStatus.success) {
        await GomsDialog.single(
          title: '후기 등록 완료',
          content: '후기를 성공적으로 등록했습니다!',
          confirmText: '돌아가기',
          onConfirm: () {
            if (context.mounted) context.pop();
          },
        ).show(context);
      } else if (next.status == WriteReviewStatus.failure &&
          next.errorMessage != null) {
        notifier.clearError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    });

    return BaseScaffold(
      showAppBar: true,
      onBackPressed: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '후기 남기기',
            style: AppTextStyles.title1.copyWith(
              color: isLight ? AppColors.mainText : AppColors.mainTextDark,
            ),
          ),
          AppGap.v24,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.placeName,
                          style: AppTextStyles.title3.copyWith(
                            color: isLight
                                ? AppColors.mainText
                                : AppColors.mainTextDark,
                          ),
                        ),
                        AppGap.h4,
                        Text(
                          widget.category,
                          style: AppTextStyles.text3.copyWith(
                            color:
                                isLight ? AppColors.sub1 : AppColors.sub1Dark,
                          ),
                        ),
                      ],
                    ),
                    AppGap.v4,
                    Text(
                      widget.address,
                      style: AppTextStyles.text2.copyWith(
                        color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                      ),
                    ),
                    AppGap.v4,
                    Text(
                      '학생 후기 ${widget.review} | 추천 ${widget.recommended}',
                      style: AppTextStyles.text2.copyWith(
                        color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                      ),
                    ),
                  ],
                ),
              ),
              AppIcons.heart(
                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
              ),
            ],
          ),
          AppGap.v16,
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: notifier.controller,
                      maxLength: WriteReviewNotifier.maxLength,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      enabled: !isLoading,
                      onChanged: notifier.onTextChanged,
                      decoration: InputDecoration(
                        hintText: '가게 이용 후기를 남겨주세요!',
                        hintStyle: AppTextStyles.text3.copyWith(
                          color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTextStyles.text2.copyWith(
                        color: isLight
                            ? AppColors.mainText
                            : AppColors.mainTextDark,
                      ),
                    ),
                  ),
                  AppGap.v4,
                  Text(
                    '${state.reviewText.length}/${WriteReviewNotifier.maxLength}',
                    style: AppTextStyles.caption3.copyWith(
                      color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ConfirmButton(
            text: '다음',
            onPressed: notifier.isFormValid && !isLoading
                ? () => _onNextPressed(notifier)
                : null,
          ),
        ],
      ),
    );
  }
}
