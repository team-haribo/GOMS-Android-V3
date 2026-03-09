import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_setting/presentation/map_page/models/map_page_review_model.dart';
import 'package:project_setting/presentation/map_page/models/popular_place.dart';

part 'map_page_state.freezed.dart';

enum MapPageStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
abstract class MapPageState with _$MapPageState {
  const factory MapPageState({
    @Default(MapPageStatus.initial) MapPageStatus status,
    @Default(<PopularPlace>[]) List<PopularPlace> popularPlaces,
    @Default(<MapPageReviewModel>[]) List<MapPageReviewModel> reviewModels,
    @Default(0) int recommendedCount,
    @Default(0) int reviewCount,
    String? errorMessage,
  }) = _MapPageState;

  factory MapPageState.initial() => const MapPageState();
}
