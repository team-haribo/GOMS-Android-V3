import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/shared/presentation/widgets/map_bottom_sheet.dart';
import 'package:goms/features/map/discovery/presentation/models/map_screen_review_model.dart';
import 'package:goms/features/map/discovery/presentation/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/shared/presentation/widgets/place_detail_sheet.dart';
import 'package:goms/features/map/shared/presentation/widgets/place_container.dart';
import 'package:goms/features/map/shared/presentation/viewmodels/map_main_overlay_viewmodel.dart';
import 'package:goms/features/report/data/providers/report_data_providers.dart';

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
    final viewModel = ref.read(mapMainOverlayViewModelProvider);
    final recommendedPlacesCache = ref.watch(recommendedPlacesCacheProvider);

    Future<void> onToggleRecommendation(PopularPlace place) async {
      await viewModel.toggleRecommendation(place);
    }

    Future<void> onRefreshRecommended() async {
      await viewModel.refreshRecommendedPlaces();
    }

    Future<void> onDeleteReview(int reviewId) async {
      await viewModel.deleteMyReview(reviewId);
    }

    if (widget.selectedPlace != null) {
      return _SelectedPlaceOverlay(
        place: widget.selectedPlace!,
        onDismiss: widget.onSelectedPlaceDismiss,
        onToggleRecommendation: onToggleRecommendation,
        onDeleteReview: onDeleteReview,
      );
    }

    final collapsedSheetSize = MapBottomSheet.handleOnlyMinSize(context);
    final initialSheetSize = context.isTabletLayout
        ? 0.44
        : (context.screenHeight < 780 ? 0.42 : 0.38);
    final maxSheetSize = context.isTabletLayout ? 0.8 : 0.86;

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
                viewModel.updateSearchKeyword('');
              }
            },
            onSubmitted: (value) {
              viewModel.updateSearchKeyword(value.trim());
            },
            onBackPressed: () {
              _searchController.clear();
              viewModel.updateSearchKeyword('');
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
                  minChildSize: collapsedSheetSize,
                  maxChildSize: maxSheetSize,
                  snapSizes: <double>[
                    collapsedSheetSize,
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
                              onToggleRecommendation: onToggleRecommendation,
                              onRefreshRecommended: onRefreshRecommended,
                            ),
                            AppGap.v24,
                            _MyActivitySection(
                              isLight: isLight,
                              reviewModels: state.reviewModels,
                              reviewCount: state.reviewCount,
                              recommendedPlaces: recommendedPlacesCache.places
                                  .map(_toPopularPlace)
                                  .toList(growable: false),
                              recommendedCount: recommendedPlacesCache.count,
                              isRecommendedPlacesLoading:
                                  recommendedPlacesCache.isLoading,
                              onPlaceTap: widget.onPlaceTap,
                              onToggleRecommendation: onToggleRecommendation,
                              onRefreshRecommended: onRefreshRecommended,
                              onDeleteReview: onDeleteReview,
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
  final Future<void> Function(PopularPlace place) onToggleRecommendation;
  final Future<void> Function() onRefreshRecommended;

  const _PopularPlacesSection({
    required this.isLight,
    required this.state,
    required this.onToggleRecommendation,
    required this.onRefreshRecommended,
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
                  isSearching ? '검색 결과' : '최근 인기 장소',
                  style: AppTextStyles.title3.copyWith(
                    color: _mainTextColor(isLight),
                  ),
                ),
                AppGap.h2,
                if (!isSearching)
                  AppIcons.fire(
                    width: 24,
                    height: 24,
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
                  child: PlaceContainer.popular(
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
                              await onToggleRecommendation(place);
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
  final Future<void> Function(PopularPlace place) onToggleRecommendation;
  final Future<void> Function(int reviewId) onDeleteReview;

  const _SelectedPlaceOverlay({
    required this.place,
    required this.onToggleRecommendation,
    required this.onDeleteReview,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = context.isLightMode;
    final collapsedSheetSize = MapBottomSheet.handleOnlyMinSize(context);
    final initialSheetSize = context.isTabletLayout
        ? 0.44
        : (context.screenHeight < 780 ? 0.40 : 0.34);
    final maxSheetSize = context.isTabletLayout ? 0.8 : 0.86;
    final placeId = place.placeId;
    final placeDetailAsync =
        placeId == null ? null : ref.watch(placeDetailProvider(placeId));
    final placeReviewsAsync =
        placeId == null ? null : ref.watch(placeReviewsProvider(placeId));
    final myReviewIdsAsync = ref.watch(myReviewIdsProvider);
    final detailPlace = placeDetailAsync?.asData?.value;
    final resolvedPlace = place.resolveFromDetail(detailPlace);
    final reviews =
        placeReviewsAsync?.asData?.value ?? const <PlaceReviewEntity>[];
    final isReviewLoading = placeReviewsAsync?.isLoading == true;
    final myReviewIds = myReviewIdsAsync.asData?.value ?? const <int>{};

    final onTogglePressed = place.placeId == null
        ? null
        : () async {
            try {
              await onToggleRecommendation(resolvedPlace);
            } catch (_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('추천 상태를 변경하지 못했습니다.'),
                  backgroundColor: AppColors.negative,
                ),
              );
            }
          };

    Future<Null> onDeletePressed(int reviewId) async {
      try {
        await onDeleteReview(reviewId);
        if (placeId != null) {
          ref.invalidate(placeDetailProvider(placeId));
          ref.invalidate(placeReviewsProvider(placeId));
        }
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('후기 삭제에 실패했습니다.'),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    }

    Future<void> onReportReview(int reviewId, String reason) => ref
        .read(reportRepositoryProvider)
        .createReviewReport(reviewId: reviewId, reason: reason);

    return PlaceDetailSheet(
      place: resolvedPlace,
      reviews: reviews,
      myReviewIds: myReviewIds,
      isLight: isLight,
      isReviewLoading: isReviewLoading,
      initialChildSize: initialSheetSize,
      minChildSize: collapsedSheetSize,
      maxChildSize: maxSheetSize,
      snapSizes: <double>[
        collapsedSheetSize,
        initialSheetSize,
        0.58,
        maxSheetSize,
      ],
      onDismiss: onDismiss,
      onFavoritePressed: onTogglePressed,
      onArrivalPressed: () =>
          context.push(RoutePath.direction, extra: resolvedPlace),
      onDeparturePressed: () => context.push(
        '${RoutePath.direction}?start=departure',
        extra: resolvedPlace,
      ),
      onWriteReviewPressed: () =>
          context.push(RoutePath.writeReview, extra: resolvedPlace),
      onDeleteReview: onDeletePressed,
      onReportReview: onReportReview,
    );
  }

}

class _MyActivitySection extends StatelessWidget {
  final bool isLight;
  final List<MapScreenReviewModel> reviewModels;
  final int reviewCount;
  final List<PopularPlace> recommendedPlaces;
  final int recommendedCount;
  final bool isRecommendedPlacesLoading;
  final ValueChanged<PopularPlace>? onPlaceTap;
  final Future<void> Function(PopularPlace place) onToggleRecommendation;
  final Future<void> Function() onRefreshRecommended;
  final Future<void> Function(int reviewId) onDeleteReview;

  const _MyActivitySection({
    required this.isLight,
    required this.reviewModels,
    required this.reviewCount,
    required this.recommendedPlaces,
    required this.recommendedCount,
    required this.isRecommendedPlacesLoading,
    required this.onToggleRecommendation,
    required this.onRefreshRecommended,
    required this.onDeleteReview,
    this.onPlaceTap,
  });

  Future<void> _showDeleteReviewDialog({
    required BuildContext context,
    required MapScreenReviewModel review,
  }) {
    return GomsDialog.confirm(
      title: '후기 삭제',
      content: '정말 후기를 삭제하시겠습니까?',
      cancelText: '취소',
      confirmText: '삭제',
      isDestructive: true,
      onConfirm: () => _deleteReview(
        context: context,
        review: review,
      ),
    ).show(context);
  }

  void _deleteReview({
    required BuildContext context,
    required MapScreenReviewModel review,
  }) async {
    try {
      await onDeleteReview(review.reviewId);
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
  }

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
        if (isRecommendedPlacesLoading && recommendedPlaces.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (recommendedPlaces.isEmpty)
          Text(
            '아직 추천한 장소가 없습니다.',
            style: AppTextStyles.text3.copyWith(
              color: _subTextColor(isLight),
            ),
          )
        else
          ...recommendedPlaces.map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PlaceContainer.popular(
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
                          await onToggleRecommendation(place);
                          await onRefreshRecommended();
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
              child: PlaceContainer.review(
                placeName: review.placeName,
                category: review.category,
                address: review.address,
                reviewContent: review.reviewDetailContent,
                reviewCreatedAt: review.createdAt ?? DateTime.now(),
                onActionPressed: () => _showDeleteReviewDialog(
                  context: context,
                  review: review,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

PopularPlace _toPopularPlace(RecommendedPlaceEntity place) {
  return PopularPlace.fromRecommendedPlace(
    place,
    fallbackCoordinate: gomsFallbackSchoolCoordinate,
  );
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
