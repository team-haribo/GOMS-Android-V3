import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/presentation/pages/base/widgets/map_shared_widgets.dart';
import 'package:goms/features/map/presentation/pages/main/models/map_page_state.dart';
import 'package:goms/features/map/presentation/pages/main/models/popular_place.dart';
import 'package:goms/features/map/presentation/widgets/arrival_departure_button.dart';

class MapDetailOverlay extends StatelessWidget {
  final PopularPlace place;
  final MapPageState state;

  const MapDetailOverlay({
    super.key,
    required this.place,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 24,
          child: SafeArea(
            bottom: false,
            child: _BackButton(isLight: isLight),
          ),
        ),
        Positioned.fill(
          child: DraggableScrollableSheet(
            initialChildSize: 0.34,
            minChildSize: 0.34,
            maxChildSize: 0.82,
            snap: true,
            snapSizes: const [0.34, 0.56, 0.82],
            builder: (context, scrollController) {
              return MapSheet(
                isLight: isLight,
                scrollController: scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PlaceSummary(place: place, isLight: isLight),
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
                                  extra: place,
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
                                    '${state.reviewModels.length}건',
                                    style: AppTextStyles.text3.copyWith(
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          AppGap.v16,
                          if (state.reviewModels.isEmpty)
                            _EmptyReviewState(isLight: isLight)
                          else
                            ...state.reviewModels.map(
                              (review) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ReviewTile(
                                  title: review.placeName,
                                  content: review.reviewDetailContent,
                                  createdAt: review.createdAt,
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
              );
            },
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
          color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AppIcons.back(
            width: 24,
            height: 24,
            color: isLight ? AppColors.mainText : AppColors.mainTextDark,
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
  final DateTime createdAt;
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
            '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}',
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
        color: isLight ? AppColors.bgMapContainer : AppColors.bgMapContainerDark,
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



