import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/text_fields/search_text_field.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/shared/ui/widgets/map_bottom_sheet.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_review_model.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/discovery/ui/providers/map_screen_provider.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/shared/ui/widgets/place_detail_sheet.dart';
import 'package:goms/features/map/shared/ui/widgets/place_container.dart';

class MapMainOverlay extends ConsumerStatefulWidget {
  final MapScreenState state;
  final PopularPlace? selectedPlace;
  final ValueChanged<PopularPlace>? onPlaceTap;
  final VoidCallback? onSelectedPlaceDismiss;

  const MapMainOverlay({
    super.key,
    required this.state,
    this.selectedPlace,
    this.onPlaceTap,
    this.onSelectedPlaceDismiss,
  });

  @override
  ConsumerState<MapMainOverlay> createState() => _MapMainOverlayState();
}

class _MapMainOverlayState extends ConsumerState<MapMainOverlay> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isLight = context.isLightMode;
    final horizontalPadding = context.horizontalPadding;
    final topPadding = context.responsive(compact: 12, normal: 16, tablet: 20);

    if (widget.selectedPlace != null) {
      return _SelectedPlaceOverlay(
        place: widget.selectedPlace!,
        onDismiss: widget.onSelectedPlaceDismiss,
      );
    }

    final initialSheetSize = context.isTabletLayout
        ? 0.44
        : (context.screenHeight < 780 ? 0.42 : 0.38);
    final maxSheetSize = context.isTabletLayout ? 0.8 : 0.88;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            0,
          ),
          child: SearchTextField(
            controller: _searchController,
            onChanged: (value) {
              if (value.trim().isEmpty) {
                ref.read(placeSearchKeywordProvider.notifier).state = '';
              }
            },
            onSubmitted: (value) {
              ref.read(placeSearchKeywordProvider.notifier).state =
                  value.trim();
            },
            onBackPressed: () {
              _searchController.clear();
              ref.read(placeSearchKeywordProvider.notifier).state = '';
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: MapBottomSheet(
                  isLight: isLight,
                  initialChildSize: initialSheetSize,
                  minChildSize: initialSheetSize,
                  maxChildSize: maxSheetSize,
                  snapSizes: <double>[
                    initialSheetSize,
                    context.isTabletLayout ? 0.62 : 0.62,
                    maxSheetSize,
                  ],
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PopularPlacesSection(
                              isLight: isLight,
                              state: state,
                              onPlaceTap: widget.onPlaceTap,
                            ),
                            AppGap.v24,
                            _MyActivitySection(
                              isLight: isLight,
                              reviewModels: state.reviewModels,
                              reviewCount: state.reviewCount,
                              onPlaceTap: widget.onPlaceTap,
                            ),
                            AppGap.v24,
                          ],
                        ),
                      ),
                    ),
                  ],
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
  final MapScreenState state;
  final ValueChanged<PopularPlace>? onPlaceTap;

  const _PopularPlacesSection({
    required this.isLight,
    required this.state,
    this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final searchKeyword = ref.watch(placeSearchKeywordProvider);
        final searchResultsAsync = ref.watch(placeSearchResultsProvider);
        final isSearching = searchKeyword.trim().isNotEmpty;

        final popularPlaces = isSearching
            ? searchResultsAsync.asData?.value
                    .map(_toPopularPlace)
                    .toList(growable: false) ??
                const <PopularPlace>[]
            : state.popularPlaces;
        final status = isSearching
            ? (searchResultsAsync.isLoading
                ? MapScreenStatus.loading
                : MapScreenStatus.success)
            : state.status;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isSearching ? '검색 결과' : '인기 장소',
                  style: AppTextStyles.title3.copyWith(
                    color: _mainTextColor(isLight),
                  ),
                ),
                AppGap.h4,
                if (!isSearching)
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 18,
                    color: AppColors.negative,
                  ),
              ],
            ),
            AppGap.v16,
            if (status == MapScreenStatus.loading && popularPlaces.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (popularPlaces.isEmpty)
              Text(
                isSearching ? '검색 결과가 없습니다.' : '표시할 장소가 없습니다.',
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
                    isLiked: place.isRecommended,
                    distanceMeters: place.distanceMeters,
                    onTap: () {
                      if (onPlaceTap != null) {
                        onPlaceTap!(place);
                        return;
                      }
                      context.push(RoutePath.mapDetail, extra: place);
                    },
                    onLikePressed: place.placeId == null
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(mapScreenProvider.notifier)
                                  .toggleRecommendation(place);
                            } catch (_) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('추천 상태를 변경하지 못했습니다.'),
                                  backgroundColor: AppColors.negative,
                                ),
                              );
                            }
                          },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SelectedPlaceOverlay extends ConsumerWidget {
  final PopularPlace place;
  final VoidCallback? onDismiss;

  const _SelectedPlaceOverlay({
    required this.place,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = context.isLightMode;
    final initialSheetSize = context.isTabletLayout
        ? 0.44
        : (context.screenHeight < 780 ? 0.40 : 0.34);
    final maxSheetSize = context.isTabletLayout ? 0.78 : 0.86;
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

    return PlaceDetailSheet(
      place: resolvedPlace,
      reviews: reviews,
      isLight: isLight,
      isReviewLoading: isReviewLoading,
      initialChildSize: initialSheetSize,
      minChildSize: initialSheetSize,
      maxChildSize: maxSheetSize,
      snapSizes: <double>[initialSheetSize, 0.58, maxSheetSize],
      onDismiss: onDismiss,
      onFavoritePressed: place.placeId == null
          ? null
          : () async {
              try {
                await ref
                    .read(mapScreenProvider.notifier)
                    .toggleRecommendation(resolvedPlace);
              } catch (_) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('추천 상태를 변경하지 못했습니다.'),
                    backgroundColor: AppColors.negative,
                  ),
                );
              }
            },
      onArrivalPressed: () =>
          context.push(RoutePath.direction, extra: resolvedPlace),
      onDeparturePressed: () => context.push(
        '${RoutePath.direction}?start=departure',
        extra: resolvedPlace,
      ),
      onWriteReviewPressed: () =>
          context.push(RoutePath.writeReview, extra: resolvedPlace),
    );
  }
}

class _MyActivitySection extends StatelessWidget {
  final bool isLight;
  final List<MapScreenReviewModel> reviewModels;
  final int reviewCount;
  final ValueChanged<PopularPlace>? onPlaceTap;

  const _MyActivitySection({
    required this.isLight,
    required this.reviewModels,
    required this.reviewCount,
    this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final recommendedCountAsync = ref.watch(recommendedPlacesCountProvider);
        final recommendedPlacesAsync = ref.watch(recommendedPlacesProvider);
        final recommendedPlaces = recommendedPlacesAsync.asData?.value
                .map(_toPopularPlace)
                .toList(growable: false) ??
            const <PopularPlace>[];

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
              count: recommendedCountAsync.asData?.value ?? 0,
              unit: '곳',
              labelStyle: AppTextStyles.text1,
              countStyle: AppTextStyles.text3,
            ),
            AppGap.v12,
            if (recommendedPlacesAsync.isLoading && recommendedPlaces.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (recommendedPlaces.isEmpty)
              Text(
                '아직 추천한 장소가 없습니다.',
                style: AppTextStyles.text3.copyWith(
                  color: _subTextColor(isLight),
                ),
              )
            else
              ...recommendedPlaces.take(2).map(
                    (place) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PlaceContainer(
                        placeName: place.name,
                        category: place.category,
                        address: place.address,
                        review: place.review,
                        recommended: place.recommended,
                        isLiked: place.isRecommended,
                        distanceMeters: place.distanceMeters,
                        onTap: () {
                          if (onPlaceTap != null) {
                            onPlaceTap!(place);
                            return;
                          }
                          context.push(RoutePath.mapDetail, extra: place);
                        },
                        onLikePressed: place.placeId == null
                            ? null
                            : () async {
                                try {
                                  await ref
                                      .read(mapScreenProvider.notifier)
                                      .toggleRecommendation(place);
                                  ref.invalidate(recommendedPlacesProvider);
                                  ref.invalidate(
                                    recommendedPlacesCountProvider,
                                  );
                                } catch (_) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('추천 상태를 변경하지 못했습니다.'),
                                      backgroundColor: AppColors.negative,
                                    ),
                                  );
                                }
                              },
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
            if (reviewModels.isNotEmpty) ...[
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
          ],
        );
      },
    );
  }
}

PopularPlace _toPopularPlace(RecommendedPlaceEntity place) {
  return PopularPlace.fromRecommendedPlace(
    place,
    fallbackCoordinate: gomsFallbackSchoolCoordinate,
  );
}

class _ReviewCard extends StatelessWidget {
  final MapScreenReviewModel review;
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
