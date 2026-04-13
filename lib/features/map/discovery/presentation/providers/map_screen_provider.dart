import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/utils/logger.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/presentation/models/map_screen_review_model.dart';
import 'package:goms/features/map/discovery/presentation/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

final mapScreenProvider = NotifierProvider<MapScreenNotifier, MapScreenState>(
  MapScreenNotifier.new,
);

class MapScreenNotifier extends Notifier<MapScreenState> {
  static const _hotPlaceDays = 7;

  @override
  MapScreenState build() {
    Future.microtask(fetchData);
    return MapScreenState.initial();
  }

  Future<void> fetchData() async {
    state = state.copyWith(
      status: MapScreenStatus.loading,
      errorMessage: null,
    );

    try {
      final popularPlaces = await _loadMarkerPlaces();

      state = state.copyWith(
        status: MapScreenStatus.success,
        popularPlaces: popularPlaces,
        reviewModels: const <MapScreenReviewModel>[],
        recommendedCount: 0,
        reviewCount: 0,
      );
    } catch (error, stackTrace) {
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

  Future<List<PopularPlace>> _loadMarkerPlaces() async {
    try {
      final hotPlaces = await _loadHotPlaceEntities();
      return hotPlaces
          .map((place) => _toPopularPlace(place))
          .toList(growable: false);
    } catch (error, stackTrace) {
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

  PopularPlace _toPopularPlace(RecommendedPlaceEntity place) {
    return PopularPlace(
      placeId: place.placeId,
      name: _displayName(place),
      category: place.category ?? '장소',
      address: place.address ?? gomsSchoolAddress,
      review: place.reviewCount,
      recommended: place.recommendCount,
      isRecommended: place.recommended,
      coordinate: place.coordinate ?? gomsFallbackSchoolCoordinate,
    );
  }

  String _displayName(RecommendedPlaceEntity place) {
    final value = place.placeName?.trim();
    if (value == null || value.isEmpty) {
      return '추천 장소 ${place.placeId}';
    }
    return value;
  }
}
