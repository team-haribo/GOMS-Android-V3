import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/shared/ui/widgets/map_bottom_sheet.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/shared/ui/widgets/arrival_departure_button.dart';

class MapDetailOverlay extends ConsumerWidget {
  final PopularPlace place;
  final MapScreenState state;

  const MapDetailOverlay({
    super.key,
    required this.place,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = context.isLightMode;
    final horizontalPadding = context.horizontalPadding;
    final initialSheetSize = context.isTabletLayout
        ? 0.4
        : (context.screenHeight < 780 ? 0.4 : 0.34);
    final maxSheetSize = context.isTabletLayout ? 0.76 : 0.82;
    final placeId = place.placeId;
    final placeDetailAsync =
        placeId == null ? null : ref.watch(placeDetailProvider(placeId));
    final placeReviewsAsync =
        placeId == null ? null : ref.watch(placeReviewsProvider(placeId));

    final detailPlace = placeDetailAsync?.asData?.value;
    final resolvedPlace = detailPlace == null
        ? place
        : place.copyWith(
            name: detailPlace.placeName?.trim().isNotEmpty == true
                ? detailPlace.placeName!.trim()
                : place.name,
            category: detailPlace.category?.trim().isNotEmpty == true
                ? detailPlace.category!.trim()
                : place.category,
            address: detailPlace.address?.trim().isNotEmpty == true
                ? detailPlace.address!.trim()
                : place.address,
            review: detailPlace.reviewCount,
            recommended: detailPlace.recommendCount,
            isRecommended: detailPlace.recommended,
            coordinate: detailPlace.coordinate ?? place.coordinate,
          );
    final reviews =
        placeReviewsAsync?.asData?.value ?? const <PlaceReviewEntity>[];
    final isReviewLoading = placeReviewsAsync?.isLoading == true;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: horizontalPadding,
          child: SafeArea(
            bottom: false,
            child: _BackButton(isLight: isLight),
          ),
        ),
        Positioned.fill(
          child: MapBottomSheet(
            isLight: isLight,
            initialChildSize: initialSheetSize,
            minChildSize: initialSheetSize,
            maxChildSize: maxSheetSize,
            snapSizes: <double>[initialSheetSize, 0.56, maxSheetSize],
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PlaceSummary(place: resolvedPlace, isLight: isLight),
                      AppGap.v16,
                      Row(
                        children: [
                          ArrivalDepartureButton(
                            buttonText: '도착',
                            textColor: isLight
                                ? AppColors.background
                                : AppColors.mainTextDark,
                            backgroundColor: AppColors.mainColor,
                            onPressed: () => context.push(
                              RoutePath.direction,
                              extra: place,
                            ),
                          ),
                          AppGap.h8,
                          ArrivalDepartureButton(
                            buttonText: '후기 남기기',
                            textColor: isLight
                                ? AppColors.mainText
                                : AppColors.mainTextDark,
                            backgroundColor: isLight
                                ? AppColors.button
                                : AppColors.buttonDark,
                            onPressed: () => context.push(
                              RoutePath.writeReview,
                              extra: resolvedPlace,
                            ),
                          ),
                        ],
                      ),
                      AppGap.v24,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '학생 후기',
                                style: AppTextStyles.title3.copyWith(
                                  color: isLight
                                      ? AppColors.mainText
                                      : AppColors.mainTextDark,
                                ),
                              ),
                              AppGap.h4,
                              Text(
                                '${reviews.length}건',
                                style: AppTextStyles.text3.copyWith(
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      AppGap.v16,
                      if (isReviewLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (reviews.isEmpty)
                        _EmptyReviewState(isLight: isLight)
                      else
                        ...reviews.map(
                          (review) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ReviewTile(
                              title:
                                  '${review.name} · ${review.grade}학년 ${review.department}',
                              content: review.content,
                              createdAt: review.reviewedAt,
                              isLight: isLight,
                            ),
                          ),
                        ),
                      AppGap.v24,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  final bool isLight;

  const _BackButton({required this.isLight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AppIcons.back(
            width: 24,
            height: 24,
            color: context.mainTextColor,
          ),
        ),
      ),
    );
  }
}

class _PlaceSummary extends StatelessWidget {
  final PopularPlace place;
  final bool isLight;

  const _PlaceSummary({required this.place, required this.isLight});

  @override
  Widget build(BuildContext context) {
    final subColor = isLight ? AppColors.sub1 : AppColors.sub1Dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                place.name,
                style: AppTextStyles.title3.copyWith(
                  color: isLight ? AppColors.mainText : AppColors.mainTextDark,
                ),
              ),
            ),
            AppGap.h4,
            Text(
              place.category,
              style: AppTextStyles.text3.copyWith(color: subColor),
            ),
          ],
        ),
        AppGap.v8,
        Text(
          place.address,
          style: AppTextStyles.text2.copyWith(color: subColor),
        ),
        if (place.distanceMeters != null) ...[
          AppGap.v4,
          Text(
            '학교 기준 ${place.distanceMeters}m',
            style: AppTextStyles.text2.copyWith(color: subColor),
          ),
        ],
        AppGap.v8,
        Row(
          children: [
            Text(
              '학생 후기 ${place.review}',
              style: AppTextStyles.text2.copyWith(color: subColor),
            ),
            AppGap.h8,
            Text(
              '|',
              style: AppTextStyles.text2.copyWith(color: subColor),
            ),
            AppGap.h8,
            Text(
              '추천 ${place.recommended}',
              style: AppTextStyles.text2.copyWith(color: subColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String title;
  final String content;
  final DateTime? createdAt;
  final bool isLight;

  const _ReviewTile({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isLight ? AppColors.bgMapContainer : AppColors.bgMapContainerDark;
    final subColor = isLight ? AppColors.sub1 : AppColors.sub1Dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.text1.copyWith(
              color: isLight ? AppColors.mainText : AppColors.mainTextDark,
            ),
          ),
          AppGap.v8,
          Text(
            content,
            style: AppTextStyles.text3.copyWith(color: subColor),
          ),
          AppGap.v8,
          Text(
            createdAt == null
                ? '-'
                : '${createdAt!.year}.${createdAt!.month.toString().padLeft(2, '0')}.${createdAt!.day.toString().padLeft(2, '0')}',
            style: AppTextStyles.caption2.copyWith(color: subColor),
          ),
        ],
      ),
    );
  }
}

class _EmptyReviewState extends StatelessWidget {
  final bool isLight;

  const _EmptyReviewState({required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color:
            isLight ? AppColors.bgMapContainer : AppColors.bgMapContainerDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '아직 등록된 후기가 없습니다.',
        textAlign: TextAlign.center,
        style: AppTextStyles.text3.copyWith(
          color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
        ),
      ),
    );
  }
}
