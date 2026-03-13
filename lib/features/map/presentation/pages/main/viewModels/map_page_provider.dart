import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/presentation/pages/main/models/map_page_review_model.dart';
import 'package:goms/features/map/presentation/pages/main/models/map_page_state.dart';
import 'package:goms/features/map/presentation/pages/main/models/popular_place.dart';

final mapPageProvider = NotifierProvider<MapPageNotifier, MapPageState>(
  MapPageNotifier.new,
);

class MapPageNotifier extends Notifier<MapPageState> {
  @override
  MapPageState build() {
    Future.microtask(() => fetchData());
    return MapPageState.initial();
  }

  Future<void> fetchData() async {
    state = state.copyWith(status: MapPageStatus.loading);
    try {
      // TODO: 실제 API 호출로 교체
      await Future.delayed(const Duration(milliseconds: 300));

      const popularPlaces = <PopularPlace>[
        PopularPlace(
          name: '맛있는 식당',
          category: '한식',
          address: '서울시 강남구 역삼동',
          review: 12,
          recommended: 34,
        ),
        PopularPlace(
          name: '카페 하루',
          category: '카페',
          address: '서울시 서초구 반포동',
          review: 8,
          recommended: 22,
        ),
      ];

      final reviewModels = <MapPageReviewModel>[
        MapPageReviewModel(
          placeName: '맛있는 식당',
          category: '한식',
          address: '서울시 강남구 역삼동',
          reviewDetailContent: '정말 맛있어요! 또 방문할 의향이 있습니다.',
          createdAt: DateTime.now(),
        ),
      ];

      state = state.copyWith(
        status: MapPageStatus.success,
        popularPlaces: popularPlaces,
        reviewModels: reviewModels,
        recommendedCount: popularPlaces.length,
        reviewCount: reviewModels.length,
      );
    } catch (e) {
      state = state.copyWith(
        status: MapPageStatus.failure,
        errorMessage: '데이터를 불러오는데 실패했습니다.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      status: MapPageStatus.initial,
      errorMessage: null,
    );
  }
}


