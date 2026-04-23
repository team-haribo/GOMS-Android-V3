import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/shared/ui/widgets/map_bottom_sheet.dart';
import 'package:goms/features/map/shared/ui/widgets/place_detail_sheet.dart';

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
    final collapsedSheetSize = MapBottomSheet.handleOnlyMinSize(context);
    final initialSheetSize = context.isTabletLayout
        ? 0.4
        : (context.screenHeight < 780 ? 0.4 : 0.34);
    final maxSheetSize = context.isTabletLayout ? 0.8 : 0.86;
    final placeId = place.placeId;
    final placeDetailAsync =
        placeId == null ? null : ref.watch(placeDetailProvider(placeId));
    final placeReviewsAsync =
        placeId == null ? null : ref.watch(placeReviewsProvider(placeId));
    final myReviewIdsAsync = ref.watch(myReviewIdsProvider);

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
    final myReviewIds = myReviewIdsAsync.asData?.value ?? const <int>{};

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
          child: PlaceDetailSheet(
            place: resolvedPlace,
            reviews: reviews,
            isLight: isLight,
            isReviewLoading: isReviewLoading,
            initialChildSize: initialSheetSize,
            minChildSize: collapsedSheetSize,
            maxChildSize: maxSheetSize,
            snapSizes: <double>[
              collapsedSheetSize,
              initialSheetSize,
              0.56,
              maxSheetSize,
            ],
            myReviewIds: myReviewIds,
            showTrailingActions: false,
            onArrivalPressed: () =>
                context.push(RoutePath.direction, extra: place),
            onDeparturePressed: () => context.push(
              '${RoutePath.direction}?start=departure',
              extra: resolvedPlace,
            ),
            onWriteReviewPressed: () =>
                context.push(RoutePath.writeReview, extra: resolvedPlace),
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
