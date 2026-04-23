import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/utils/logger.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_review_model.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

final mapScreenProvider = NotifierProvider<MapScreenNotifier, MapScreenState>(
  MapScreenNotifier.new,
);

class MapScreenNotifier extends Notifier<MapScreenState> {
  static const _hotPlaceDays = 7;

  @override
  MapScreenState build() {
    return MapScreenState.initial();
  }

  Future<void> fetchData() async {
    if (!ref.mounted) {
      return;
    }

    state = state.copyWith(
      status: MapScreenStatus.loading,
      errorMessage: null,
    );

    try {
      final popularPlaces = await _loadMarkerPlaces();
      final myReviewModels = await _loadMyReviewModels();
      final myReviewCount = await _loadMyReviewCount(
        fallbackCount: myReviewModels.length,
      );
      final effectiveMyReviewCount = _resolveMyReviewCount(
        reviews: myReviewModels,
        reviewCount: myReviewCount,
      );
      if (!ref.mounted) {
        return;
      }

      state = state.copyWith(
        status: MapScreenStatus.success,
        popularPlaces: popularPlaces,
        reviewModels: myReviewModels,
        reviewCount: effectiveMyReviewCount,
      );
    } catch (error, stackTrace) {
      if (!ref.mounted) {
        return;
      }
      Logger.e(
        'Failed to load place markers.',
        tag: 'MAP',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        status: MapScreenStatus.failure,
        errorMessage: '장소 정보를 불러오는데 실패했습니다.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      status: MapScreenStatus.initial,
      errorMessage: null,
    );
  }

  Future<void> toggleRecommendation(PopularPlace place) async {
    final placeId = place.placeId;
    if (placeId == null) {
      return;
    }

    final previousPlaces = state.popularPlaces;
    final toggledPlaces = previousPlaces
        .map(
          (item) => item.placeId == placeId
              ? item.copyWith(
                  isRecommended: !item.isRecommended,
                  recommended: item.isRecommended
                      ? max(0, item.recommended - 1)
                      : item.recommended + 1,
                )
              : item,
        )
        .toList(growable: false);

    state = state.copyWith(popularPlaces: toggledPlaces);

    try {
      final nextRecommended = place.isRecommended
          ? await ref
              .read(recommendedPlaceRepositoryProvider)
              .unRecommendPlace(placeId)
          : await ref
              .read(recommendedPlaceRepositoryProvider)
              .recommendPlace(placeId);

      state = state.copyWith(
        popularPlaces: toggledPlaces
            .map(
              (item) => item.placeId == placeId
                  ? item.copyWith(isRecommended: nextRecommended)
                  : item,
            )
            .toList(growable: false),
      );
      ref.invalidate(recommendedPlacesProvider);
      ref.invalidate(recommendedPlacesCountProvider);
      ref.invalidate(placeDetailProvider(placeId));
    } catch (_) {
      state = state.copyWith(popularPlaces: previousPlaces);
      rethrow;
    }
  }

  Future<void> deleteMyReview(int reviewId) async {
    final previousReviewModels = state.reviewModels;
    final previousReviewCount = state.reviewCount;

    final nextReviewModels = previousReviewModels
        .where((review) => review.reviewId != reviewId)
        .toList(growable: false);

    final isActuallyRemoved =
        nextReviewModels.length != previousReviewModels.length;
    final nextReviewCount = isActuallyRemoved
        ? max(0, previousReviewCount - 1)
        : previousReviewCount;

    state = state.copyWith(
      reviewModels: nextReviewModels,
      reviewCount: nextReviewCount,
    );

    try {
      await ref.read(recommendedPlaceRepositoryProvider).deleteReview(reviewId);
      ref.invalidate(recommendedPlacesProvider);
      ref.invalidate(recommendedPlacesCountProvider);
      ref.invalidate(myReviewIdsProvider);
    } catch (_) {
      state = state.copyWith(
        reviewModels: previousReviewModels,
        reviewCount: previousReviewCount,
      );
      rethrow;
    }
  }

  Future<List<PopularPlace>> _loadMarkerPlaces() async {
    try {
      final hotPlaces = await _loadHotPlaceEntities();
      if (hotPlaces.isEmpty) {
        final places =
            await ref.read(recommendedPlaceRepositoryProvider).getPlaces();
        return places
            .map((place) => _toPopularPlace(place))
            .toList(growable: false);
      }
      return hotPlaces
          .map((place) => _toPopularPlace(place))
          .toList(growable: false);
    } catch (error, stackTrace) {
      if (!ref.mounted) {
        return const <PopularPlace>[];
      }
      Logger.e(
        'Hot place request failed. Falling back to all places.',
        tag: 'MAP',
        error: error,
        stackTrace: stackTrace,
      );

      final places =
          await ref.read(recommendedPlaceRepositoryProvider).getPlaces();
      return places
          .map((place) => _toPopularPlace(place))
          .toList(growable: false);
    }
  }

  Future<List<RecommendedPlaceEntity>> _loadHotPlaceEntities() async {
    return ref
        .read(recommendedPlaceRepositoryProvider)
        .getHotPlaces(days: _hotPlaceDays);
  }

  Future<List<MapScreenReviewModel>> _loadMyReviewModels() async {
    try {
      final reviews =
          await ref.read(recommendedPlaceRepositoryProvider).getMyReviews();
      return reviews.map(_toMapScreenReviewModel).toList(growable: false);
    } catch (error, stackTrace) {
      if (ref.mounted) {
        Logger.e(
          'My review list request failed. Falling back to empty list.',
          tag: 'MAP',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return const <MapScreenReviewModel>[];
    }
  }

  Future<int> _loadMyReviewCount({required int fallbackCount}) async {
    try {
      return await ref
          .read(recommendedPlaceRepositoryProvider)
          .getMyReviewCount();
    } catch (error, stackTrace) {
      if (ref.mounted) {
        Logger.e(
          'My review count request failed. Falling back to list length.',
          tag: 'MAP',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return fallbackCount;
    }
  }

  MapScreenReviewModel _toMapScreenReviewModel(MyReviewEntity review) {
    return MapScreenReviewModel(
      placeName: review.placeName,
      category: review.categoryName,
      address: review.address,
      reviewDetailContent: review.content,
      createdAt: review.reviewedAt ?? DateTime.now(),
      reviewId: review.reviewId,
    );
  }

  int _resolveMyReviewCount({
    required List<MapScreenReviewModel> reviews,
    required int reviewCount,
  }) {
    if (reviewCount < 0) {
      return reviews.length;
    }

    if (reviews.length > reviewCount) {
      Logger.e(
        'My review list size (${reviews.length}) exceeded my review count ($reviewCount). '
        'Using list size to keep the written reviews visible.',
        tag: 'MAP',
      );
      return reviews.length;
    }

    return reviewCount;
  }

  PopularPlace _toPopularPlace(RecommendedPlaceEntity place) {
    return PopularPlace.fromRecommendedPlace(
      place,
      fallbackAddress: gomsSchoolAddress,
      fallbackCoordinate: gomsFallbackSchoolCoordinate,
    );
  }
}
