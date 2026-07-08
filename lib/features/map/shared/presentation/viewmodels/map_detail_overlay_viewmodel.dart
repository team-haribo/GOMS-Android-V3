import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/discovery/presentation/providers/map_screen_provider.dart';
import 'package:goms/features/report/data/providers/report_data_providers.dart';

final mapDetailOverlayViewModelProvider =
    Provider.family<MapDetailOverlayViewModel, PopularPlace>(
  (ref, place) => MapDetailOverlayViewModel(ref: ref, place: place),
);

class MapDetailOverlayViewModel {
  final Ref ref;
  final PopularPlace place;

  MapDetailOverlayViewModel({required this.ref, required this.place});

  Future<void> toggleRecommendation(PopularPlace currentPlace) async {
    await ref
        .read(mapScreenProvider.notifier)
        .toggleRecommendation(currentPlace);
  }

  Future<void> deleteMyReview(int reviewId, int? placeId) async {
    await ref.read(mapScreenProvider.notifier).deleteMyReview(reviewId);
    if (placeId != null) {
      ref.invalidate(placeDetailProvider(placeId));
      ref.invalidate(placeReviewsProvider(placeId));
    }
  }

  Future<void> reportReview(int reviewId, String reason) async {
    await ref
        .read(reportRemoteDataSourceProvider)
        .createReviewReport(reviewId: reviewId, reason: reason);
  }
}
