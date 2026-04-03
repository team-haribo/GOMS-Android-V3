import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final recommendedPlaces = await _loadRecommendedPlaceEntities();
      final popularPlaces = recommendedPlaces
          .map((place) => _toPopularPlace(place))
          .toList(growable: false);
      final reviewModels = _buildReviewModels(popularPlaces);

      state = state.copyWith(
        status: MapScreenStatus.success,
        popularPlaces: popularPlaces,
        reviewModels: reviewModels,
        recommendedCount: recommendedPlaces.length,
        reviewCount: _totalReviewCount(recommendedPlaces),
      );
    } catch (_) {
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

  Future<List<RecommendedPlaceEntity>> _loadRecommendedPlaceEntities() async {
    try {
      return (await ref.read(getRecommendedPlacesUseCaseProvider).call())
          .where((place) => place.recommended)
          .toList(growable: false);
    } on DioException {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  PopularPlace _toPopularPlace(RecommendedPlaceEntity place) {
    return PopularPlace(
      placeId: place.placeId,
      name: _displayName(place),
      category: place.category ?? '장소',
      address: place.address ?? gomsSchoolAddress,
      review: place.reviewCount,
      recommended: place.recommendCount,
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

  List<MapScreenReviewModel> _buildReviewModels(List<PopularPlace> places) {
    final reviewedPlaces = places.where((place) => place.review > 0).toList();
    if (reviewedPlaces.isEmpty) {
      return const [];
    }

    return reviewedPlaces
        .take(min(2, reviewedPlaces.length))
        .toList()
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final place = entry.value;
      return MapScreenReviewModel(
        placeName: place.name,
        category: place.category,
        address: place.address,
        reviewDetailContent:
            '${place.name}에서 작성한 후기 ${place.review}건이 연결되었습니다.',
        createdAt: DateTime.now().subtract(Duration(days: index + 1)),
      );
    }).toList(growable: false);
  }

  int _totalReviewCount(List<RecommendedPlaceEntity> recommendedPlaces) {
    return recommendedPlaces.fold<int>(
      0,
      (total, place) => total + place.reviewCount,
    );
  }
}
