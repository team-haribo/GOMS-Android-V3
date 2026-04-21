import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/shared/ui/widgets/arrival_departure_button.dart';
import 'package:goms/features/map/shared/ui/widgets/map_bottom_sheet.dart';
import 'package:goms/features/map/shared/ui/widgets/review_list_container.dart';

class PlaceDetailSheet extends StatelessWidget {
  final PopularPlace place;
  final List<PlaceReviewEntity> reviews;
  final bool isLight;
  final bool isReviewLoading;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final List<double> snapSizes;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onDismiss;
  final VoidCallback onArrivalPressed;
  final VoidCallback onDeparturePressed;
  final VoidCallback onWriteReviewPressed;
  final bool showTrailingActions;
  final Set<int> myReviewIds;

  const PlaceDetailSheet({
    super.key,
    required this.place,
    required this.reviews,
    required this.isLight,
    required this.isReviewLoading,
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
    required this.snapSizes,
    required this.onArrivalPressed,
    required this.onDeparturePressed,
    required this.onWriteReviewPressed,
    this.onFavoritePressed,
    this.onDismiss,
    this.showTrailingActions = true,
    this.myReviewIds = const <int>{},
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.horizontalPadding;

    return MapBottomSheet(
      isLight: isLight,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      snapSizes: snapSizes,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PlaceSummaryHeader(
                  place: place,
                  isLight: isLight,
                  showTrailingActions: showTrailingActions,
                  onFavoritePressed: onFavoritePressed,
                  onDismiss: onDismiss,
                ),
                AppGap.v20,
                _DirectionButtons(
                  isLight: isLight,
                  onArrivalPressed: onArrivalPressed,
                  onDeparturePressed: onDeparturePressed,
                ),
                AppGap.v24,
                _ReviewSectionHeader(
                  reviewCount: reviews.length,
                  isLight: isLight,
                  onWriteReviewPressed: onWriteReviewPressed,
                ),
                AppGap.v20,
                if (isReviewLoading)
                  const Center(child: CircularProgressIndicator())
                else if (reviews.isEmpty)
                  _EmptyReviewState(isLight: isLight)
                else
                  ...reviews.map(
                    (review) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ReviewListContainer(
                        reviewId: review.reviewId,
                        name: review.name,
                        grade: review.grade,
                        major: review.department,
                        reviewDetailContent: review.content,
                        createdAt: review.reviewedAt ?? DateTime.now(),
                        isMine: myReviewIds.contains(review.reviewId),
                      ),
                    ),
                  ),
                AppGap.v24,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceSummaryHeader extends StatelessWidget {
  final PopularPlace place;
  final bool isLight;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onDismiss;
  final bool showTrailingActions;

  const _PlaceSummaryHeader({
    required this.place,
    required this.isLight,
    required this.showTrailingActions,
    this.onFavoritePressed,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = isLight ? AppColors.mainText : AppColors.mainTextDark;
    final subColor = isLight ? AppColors.sub1 : AppColors.sub1Dark;
    final metaText = _buildDistanceAndDuration(place.distanceMeters);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      Flexible(
                        child: Text(
                          place.name,
                          style:
                              AppTextStyles.title3.copyWith(color: mainColor),
                        ),
                      ),
                      if (place.category.trim().isNotEmpty) ...[
                        AppGap.h4,
                        Flexible(
                          child: Text(
                            place.category,
                            style:
                                AppTextStyles.text3.copyWith(color: subColor),
                          ),
                        ),
                      ],
                    ],
                  ),
                  AppGap.v8,
                  Text(
                    place.address,
                    style: AppTextStyles.text2.copyWith(color: subColor),
                  ),
                  if (metaText != null) ...[
                    AppGap.v4,
                    Text(
                      metaText,
                      style: AppTextStyles.text2.copyWith(color: subColor),
                    ),
                  ],
                  AppGap.v4,
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.text2.copyWith(color: subColor),
                      children: [
                        const TextSpan(text: '학생 후기 '),
                        TextSpan(
                          text: '${place.review}',
                          style: AppTextStyles.text2.copyWith(
                            color: AppColors.mainColor,
                          ),
                        ),
                        TextSpan(
                          text: ' | 추천 ${place.recommended}',
                          style: AppTextStyles.text2.copyWith(color: subColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showTrailingActions)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.s12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TopIconButton(
                      onPressed: onFavoritePressed,
                      child: place.isRecommended
                          ? AppIcons.heartFilled(width: 24, height: 24)
                          : AppIcons.heart(
                              width: 24,
                              height: 24,
                              color: subColor,
                            ),
                    ),
                    AppGap.h8,
                    _TopIconButton(
                      onPressed: onDismiss,
                      child: Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: subColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const _TopIconButton({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        splashRadius: 18,
        onPressed: onPressed,
        icon: child,
      ),
    );
  }
}

class _DirectionButtons extends StatelessWidget {
  final bool isLight;
  final VoidCallback onArrivalPressed;
  final VoidCallback onDeparturePressed;

  const _DirectionButtons({
    required this.isLight,
    required this.onArrivalPressed,
    required this.onDeparturePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ArrivalDepartureButton(
          buttonText: '도착',
          width: 89,
          height: 33,
          textStyle: AppTextStyles.text2,
          textColor: isLight ? AppColors.background : AppColors.mainTextDark,
          backgroundColor: AppColors.mainColor,
          onPressed: onArrivalPressed,
        ),
        AppGap.h4,
        ArrivalDepartureButton(
          buttonText: '출발',
          width: 89,
          height: 33,
          textStyle: AppTextStyles.text2,
          textColor: isLight ? AppColors.sub2 : AppColors.sub1Dark,
          backgroundColor: isLight ? AppColors.button : AppColors.buttonDark,
          onPressed: onDeparturePressed,
        ),
      ],
    );
  }
}

class _ReviewSectionHeader extends StatelessWidget {
  final int reviewCount;
  final bool isLight;
  final VoidCallback onWriteReviewPressed;

  const _ReviewSectionHeader({
    required this.reviewCount,
    required this.isLight,
    required this.onWriteReviewPressed,
  });

  @override
  Widget build(BuildContext context) {
    final subColor = isLight ? AppColors.sub2 : AppColors.sub1Dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '학생 후기',
              style: AppTextStyles.title3.copyWith(
                color: isLight ? AppColors.mainText : AppColors.mainTextDark,
              ),
            ),
            AppGap.h4,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$reviewCount',
                    style: AppTextStyles.text3.copyWith(
                      color: AppColors.mainColor,
                    ),
                  ),
                  TextSpan(
                    text: '건',
                    style: AppTextStyles.text3.copyWith(color: subColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: onWriteReviewPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: AppIcons.tablerEdit(
            width: 24,
            height: 24,
            color: subColor,
          ),
          label: Text(
            '후기 남기기',
            style: AppTextStyles.text2.copyWith(color: subColor),
          ),
        ),
      ],
    );
  }
}

class _EmptyReviewState extends StatelessWidget {
  final bool isLight;

  const _EmptyReviewState({required this.isLight});

  @override
  Widget build(BuildContext context) {
    final subColor = isLight ? AppColors.sub2 : AppColors.sub1Dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s24,
      ),
      decoration: BoxDecoration(
        color:
            isLight ? AppColors.bgMapContainer : AppColors.bgMapContainerDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          AppIcons.coffee(
            width: 84,
            height: 84,
            color: subColor,
          ),
          AppGap.v16,
          Text(
            '아직 후기가 없어요!\n첫 후기를 작성해봐요!',
            textAlign: TextAlign.center,
            style: AppTextStyles.text3.copyWith(color: subColor),
          ),
        ],
      ),
    );
  }
}

String? _buildDistanceAndDuration(int? distanceMeters) {
  if (distanceMeters == null) {
    return null;
  }

  final estimatedMinutes = ((distanceMeters / 67).ceil()).clamp(1, 99);
  return '$distanceMeters' 'm | $estimatedMinutes분';
}
