import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/services/kakao_local_service.dart';
import 'package:goms/features/map/data/services/map_service_providers.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/presentation/models/map_screen_review_model.dart';
import 'package:goms/features/map/discovery/presentation/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';

final mapScreenProvider = NotifierProvider<MapScreenNotifier, MapScreenState>(
  MapScreenNotifier.new,
);

class MapScreenNotifier extends Notifier<MapScreenState> {
  late final KakaoLocalService _localService;

  @override
  MapScreenState build() {
    _localService = ref.read(kakaoLocalServiceProvider);
    Future.microtask(fetchData);
    return MapScreenState.initial();
  }

  Future<void> fetchData() async {
    state = state.copyWith(status: MapScreenStatus.loading);

    try {
      final schoolCoordinate = await _resolveSchoolCoordinate();
      final popularPlaces = await _loadNearbyPlaces(schoolCoordinate);
      final reviewModels = _buildReviewModels(popularPlaces);

      state = state.copyWith(
        status: MapScreenStatus.success,
        popularPlaces: popularPlaces,
        reviewModels: reviewModels,
        recommendedCount: popularPlaces.length,
        reviewCount: reviewModels.length,
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

  Future<List<PopularPlace>> _loadNearbyPlaces(
    MapCoordinate schoolCoordinate,
  ) async {
    const keywords = ['카페', '한식', '분식', '편의점'];
    final places = <PopularPlace>[];
    final seenKeys = <String>{};

    for (var index = 0; index < keywords.length; index++) {
      final results = await _localService.searchNearbyByKeyword(
        query: keywords[index],
        center: schoolCoordinate,
        radius: 1800,
        size: 4,
      );

      for (final result in results) {
        final key = '${result.name}-${result.address}';
        if (!seenKeys.add(key)) {
          continue;
        }

        places.add(
          PopularPlace(
            name: result.name,
            category: result.category,
            address: result.address,
            review: 3 + (index * 2),
            recommended: 8 + (index * 3),
            distanceMeters: result.distanceMeters,
            coordinate: result.coordinate,
          ),
        );

        if (places.length >= 4) {
          return places;
        }
      }
    }

    if (places.isNotEmpty) {
      return places;
    }

    return [
      PopularPlace(
        name: gomsSchoolName,
        category: '학교',
        address: gomsSchoolAddress,
        review: 0,
        recommended: 0,
        distanceMeters: 0,
        coordinate: schoolCoordinate,
      ),
    ];
  }

  Future<MapCoordinate> _resolveSchoolCoordinate() async {
    try {
      return await _localService.resolveAddress(gomsSchoolAddress);
    } on KakaoApiException {
      return gomsFallbackSchoolCoordinate;
    }
  }

  List<MapScreenReviewModel> _buildReviewModels(List<PopularPlace> places) {
    if (places.isEmpty) {
      return const [];
    }

    return places.take(min(2, places.length)).map((place) {
      return MapScreenReviewModel(
        placeName: place.name,
        category: place.category,
        address: place.address,
        reviewDetailContent: '${place.name} 방문 후기가 자동으로 연결되었습니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );
    }).toList();
  }
}
