import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_review_model.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';

part 'map_screen_state.freezed.dart';

enum MapScreenStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
abstract class MapScreenState with _$MapScreenState {
  const factory MapScreenState({
    @Default(MapScreenStatus.initial) MapScreenStatus status,
    @Default(<PopularPlace>[]) List<PopularPlace> popularPlaces,
    @Default(<MapScreenReviewModel>[]) List<MapScreenReviewModel> reviewModels,
    @Default(0) int recommendedCount,
    @Default(0) int reviewCount,
    String? errorMessage,
  }) = _MapScreenState;

  factory MapScreenState.initial() => const MapScreenState();
}
