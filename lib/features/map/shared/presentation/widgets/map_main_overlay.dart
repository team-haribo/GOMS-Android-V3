import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/text_fields/search_text_field.dart';
import 'package:goms/features/map/shared/presentation/widgets/map_shared_widgets.dart';
import 'package:goms/features/map/discovery/presentation/models/map_page_review_model.dart';
import 'package:goms/features/map/discovery/presentation/models/map_page_state.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/shared/presentation/widgets/place_container.dart';

class MapMainOverlay extends StatelessWidget {
  final MapPageState state;

  const MapMainOverlay({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = context.isLightMode;
    final horizontalPadding = context.horizontalPadding;
    final topPadding = context.responsive(compact: 12, normal: 16, tablet: 20);
    final initialSheetSize = context.isTabletLayout
        ? 0.44
        : (context.screenHeight < 780 ? 0.42 : 0.38);
    final maxSheetSize = context.isTabletLayout ? 0.8 : 0.88;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              horizontalPadding, topPadding, horizontalPadding, 0),
          child: const SearchTextField(),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: initialSheetSize,
                  minChildSize: initialSheetSize,
                  maxChildSize: maxSheetSize,
                  snap: true,
                  snapSizes: <double>[
                    initialSheetSize,
                    context.isTabletLayout ? 0.62 : 0.62,
                    maxSheetSize,
                  ],
                  builder: (context, scrollController) {
                    return MapSheet(
                      isLight: isLight,
                      scrollController: scrollController,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _PopularPlacesSection(
                                  isLight: isLight,
                                  status: state.status,
                                  popularPlaces: state.popularPlaces,
                                ),
                                AppGap.v24,
                                _MyActivitySection(
                                  isLight: isLight,
                                  popularPlaces: state.popularPlaces,
                                  reviewModels: state.reviewModels,
                                  recommendedCount: state.recommendedCount,
                                  reviewCount: state.reviewCount,
                                ),
                                AppGap.v24,
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: context.responsive(compact: 44, normal: 56, tablet: 64),
                child: _BottomGradient(isLight: isLight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PopularPlacesSection extends StatelessWidget {
  final bool isLight;
  final MapPageStatus status;
  final List<PopularPlace> popularPlaces;

  const _PopularPlacesSection({
    required this.isLight,
    required this.status,
    required this.popularPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '인기 장소',
              style: AppTextStyles.title3.copyWith(
                color: _mainTextColor(isLight),
              ),
            ),
            AppGap.h4,
            AppIcons.fire(width: 18, height: 18, color: AppColors.negative),
          ],
        ),
        AppGap.v16,
        if (status == MapPageStatus.loading && popularPlaces.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (popularPlaces.isEmpty)
          Text(
            '표시할 장소가 없습니다.',
            style: AppTextStyles.text3.copyWith(
              color: _subTextColor(isLight),
            ),
          )
        else
          ...popularPlaces.map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PlaceContainer(
                placeName: place.name,
                category: place.category,
                address: place.address,
                review: place.review,
                recommended: place.recommended,
                distanceMeters: place.distanceMeters,
                onTap: () => context.push(RoutePath.mapDetail, extra: place),
              ),
            ),
          ),
      ],
    );
  }
}

class _MyActivitySection extends StatelessWidget {
  final bool isLight;
  final List<PopularPlace> popularPlaces;
  final List<MapPageReviewModel> reviewModels;
  final int recommendedCount;
  final int reviewCount;

  const _MyActivitySection({
    required this.isLight,
    required this.popularPlaces,
    required this.reviewModels,
    required this.recommendedCount,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 활동',
          style: AppTextStyles.title3.copyWith(
            color: _mainTextColor(isLight),
          ),
        ),
        AppGap.v16,
        _ActivityCountRow(
          isLight: isLight,
          label: '추천한 가게',
          count: recommendedCount,
          unit: '곳',
          labelStyle: AppTextStyles.text1,
          countStyle: AppTextStyles.text3,
        ),
        AppGap.v12,
        ...popularPlaces.take(2).map(
              (place) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PlaceContainer(
                  placeName: place.name,
                  category: place.category,
                  address: place.address,
                  review: place.review,
                  recommended: place.recommended,
                  distanceMeters: place.distanceMeters,
                  onTap: () => context.push(RoutePath.mapDetail, extra: place),
                ),
              ),
            ),
        AppGap.v12,
        _ActivityCountRow(
          isLight: isLight,
          label: '작성한 후기',
          count: reviewCount,
          unit: '건',
          labelStyle: AppTextStyles.text1,
          countStyle: AppTextStyles.text3,
        ),
        AppGap.v12,
        ...reviewModels.map(
          (review) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReviewCard(
              review: review,
              isLight: isLight,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final MapPageReviewModel review;
  final bool isLight;

  const _ReviewCard({
    required this.review,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color:
            isLight ? AppColors.bgMapContainer : AppColors.bgMapContainerDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  review.placeName,
                  style: AppTextStyles.text1.copyWith(
                    color: _mainTextColor(isLight),
                  ),
                ),
              ),
              AppGap.h4,
              Text(
                review.category,
                style: AppTextStyles.caption2.copyWith(
                  color: _subTextColor(isLight),
                ),
              ),
            ],
          ),
          AppGap.v4,
          Text(
            review.address,
            style: AppTextStyles.caption1.copyWith(
              color: _subTextColor(isLight),
            ),
          ),
          AppGap.v12,
          Text(
            review.reviewDetailContent,
            style: AppTextStyles.text3.copyWith(
              color: _mainTextColor(isLight),
            ),
          ),
          AppGap.v12,
          Text(
            DateFormat('yy.MM.dd').format(review.createdAt),
            style: AppTextStyles.caption2.copyWith(
              color: _subTextColor(isLight),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCountRow extends StatelessWidget {
  final bool isLight;
  final String label;
  final int count;
  final String unit;
  final TextStyle labelStyle;
  final TextStyle countStyle;

  const _ActivityCountRow({
    required this.isLight,
    required this.label,
    required this.count,
    required this.unit,
    required this.labelStyle,
    required this.countStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: labelStyle.copyWith(
            color: _mainTextColor(isLight),
          ),
        ),
        AppGap.h4,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$count',
                style: countStyle.copyWith(color: AppColors.mainColor),
              ),
              TextSpan(
                text: unit,
                style: countStyle.copyWith(
                  color: _subTextColor(isLight),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomGradient extends StatelessWidget {
  final bool isLight;

  const _BottomGradient({required this.isLight});

  @override
  Widget build(BuildContext context) {
    final baseColor = isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark;

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              baseColor.withValues(alpha: 0),
              baseColor,
            ],
          ),
        ),
      ),
    );
  }
}

Color _mainTextColor(bool isLight) {
  return isLight ? AppColors.mainText : AppColors.mainTextDark;
}

Color _subTextColor(bool isLight) {
  return isLight ? AppColors.sub1 : AppColors.sub1Dark;
}
