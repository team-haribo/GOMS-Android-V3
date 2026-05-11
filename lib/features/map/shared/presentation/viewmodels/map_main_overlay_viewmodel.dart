import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/discovery/presentation/providers/map_screen_provider.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';

final mapMainOverlayViewModelProvider =
    Provider<MapMainOverlayViewModel>((ref) {
  return MapMainOverlayViewModel(ref: ref);
});

class MapMainOverlayViewModel {
  final Ref ref;

  MapMainOverlayViewModel({required this.ref});

  Future<void> toggleRecommendation(PopularPlace place) async {
    await ref.read(mapScreenProvider.notifier).toggleRecommendation(place);
  }

  Future<void> deleteMyReview(int reviewId) async {
    await ref.read(mapScreenProvider.notifier).deleteMyReview(reviewId);
  }

  Future<void> refreshRecommendedPlaces() async {
    await ref.read(recommendedPlacesCacheProvider.notifier).refresh();
  }

  void updateSearchKeyword(String keyword) {
    ref.read(placeSearchKeywordProvider.notifier).state = keyword;
  }
}
