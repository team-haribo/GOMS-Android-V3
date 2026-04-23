import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/ui/providers/map_screen_provider.dart';
import 'package:goms/features/map/review/ui/models/write_review_state.dart';
import 'package:goms/features/map/review/ui/providers/write_review_provider.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/buttons/confirm_button.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final int? placeId;
  final String placeName;
  final String category;
  final String address;
  final int review;
  final int recommended;
  final bool isRecommended;

  const WriteReviewScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
    required this.isRecommended,
  });

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  late final ProviderSubscription<WriteReviewState> _writeReviewSubscription;
  late bool _isRecommended;
  late int _recommendedCount;
  bool _isRecommendationUpdating = false;

  @override
  void initState() {
    super.initState();
    _isRecommended = widget.isRecommended;
    _recommendedCount = widget.recommended;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(writeReviewProvider.notifier).reset();
    });
    _writeReviewSubscription = ref.listenManual<WriteReviewState>(
      writeReviewProvider,
      (previous, next) async {
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            final notifier = ref.read(writeReviewProvider.notifier);
            notifier.clearError();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.errorMessage!),
                backgroundColor: AppColors.negative,
              ),
            );
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _writeReviewSubscription.close();
    super.dispose();
  }

  Future<void> _onRecommendationPressed() async {
    final placeId = widget.placeId;
    if (_isRecommendationUpdating) return;

    if (placeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('장소 정보가 올바르지 않습니다.'),
          backgroundColor: AppColors.negative,
        ),
      );
      return;
    }

    final previousRecommended = _isRecommended;
    final previousCount = _recommendedCount;
    final nextRecommended = !previousRecommended;

    setState(() {
      _isRecommendationUpdating = true;
      _isRecommended = nextRecommended;
      final nextCount = previousCount + (nextRecommended ? 1 : -1);
      _recommendedCount = nextCount < 0 ? 0 : nextCount;
    });

    try {
      if (nextRecommended) {
        await ref.read(recommendedPlaceRepositoryProvider).recommendPlace(
              placeId,
            );
      } else {
        await ref.read(recommendedPlaceRepositoryProvider).unRecommendPlace(
              placeId,
            );
      }
      ref.invalidate(mapScreenProvider);
      ref.invalidate(placeDetailProvider(placeId));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isRecommended = previousRecommended;
        _recommendedCount = previousCount;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('추천 상태 변경에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: AppColors.negative,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRecommendationUpdating = false;
        });
      }
    }
  }

  void _onNextPressed(WriteReviewNotifier notifier) {
    GomsDialog.confirm(
      title: '후기 등록',
      content: '이 후기를 등록하시겠습니까?',
      cancelText: '취소',
      confirmText: '등록하기',
      onConfirm: () => notifier.submitReview(
        placeId: widget.placeId,
        placeName: widget.placeName,
        category: widget.category,
        address: widget.address,
        review: widget.review,
        recommended: _recommendedCount,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeReviewProvider);
    final notifier = ref.read(writeReviewProvider.notifier);
    final isLoading = state.status == WriteReviewStatus.loading;
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return BaseScaffold(
      showAppBar: true,
      onBackPressed: () => context.pop(),
      contentPadding: EdgeInsets.fromLTRB(
        AppSpacing.s24,
        AppSpacing.s16,
        AppSpacing.s24,
        isKeyboardVisible ? AppSpacing.s8 : AppSpacing.s24,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '후기 남기기',
                      style: AppTextStyles.title1.copyWith(
                        color: context.mainTextColor,
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
                                      color: context.mainTextColor,
                                    ),
                                  ),
                                  AppGap.h4,
                                  Text(
                                    widget.category,
                                    style: AppTextStyles.text3.copyWith(
                                      color: context.sub1Color,
                                    ),
                                  ),
                                ],
                              ),
                              AppGap.v4,
                              Text(
                                widget.address,
                                style: AppTextStyles.text2.copyWith(
                                  color: context.sub2Color,
                                ),
                              ),
                              AppGap.v4,
                              Text(
                                '학생 후기 ${widget.review} | 추천 $_recommendedCount',
                                style: AppTextStyles.text2.copyWith(
                                  color: context.sub2Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 40,
                              height: 40,
                            ),
                            splashRadius: 20,
                            onPressed: _isRecommendationUpdating
                                ? null
                                : _onRecommendationPressed,
                            icon: _isRecommended
                                ? AppIcons.heartFilled(width: 24, height: 24)
                                : AppIcons.heart(
                                    width: 24,
                                    height: 24,
                                    color: context.sub2Color,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    AppGap.v16,
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextField(
                            controller: notifier.controller,
                            maxLength: WriteReviewNotifier.maxLength,
                            maxLines: 5,
                            textAlignVertical: TextAlignVertical.top,
                            enabled: !isLoading,
                            onChanged: notifier.onTextChanged,
                            decoration: InputDecoration(
                              hintText: '가게 이용 후기를 남겨주세요!',
                              hintStyle: AppTextStyles.text3.copyWith(
                                color: context.sub2Color,
                              ),
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: AppTextStyles.text2.copyWith(
                              color: context.mainTextColor,
                            ),
                          ),
                          AppGap.v4,
                          Text(
                            '${state.reviewText.length}/${WriteReviewNotifier.maxLength}',
                            style: AppTextStyles.caption3.copyWith(
                              color: context.sub2Color,
                            ),
                          ),
                        ],
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
              ),
            ),
          );
        },
      ),
    );
  }
}
