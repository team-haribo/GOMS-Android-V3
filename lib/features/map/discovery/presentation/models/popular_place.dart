import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

part 'popular_place.freezed.dart';

@freezed
abstract class PopularPlace with _$PopularPlace {
  const factory PopularPlace({
    int? placeId,
    required String name,
    required String category,
    required String address,
    required int review,
    required int recommended,
    @Default(false) bool isRecommended,
    int? distanceMeters,
    required MapCoordinate coordinate,
  }) = _PopularPlace;

  factory PopularPlace.fromRecommendedPlace(
    RecommendedPlaceEntity place, {
    String fallbackAddress = '-',
    MapCoordinate fallbackCoordinate = gomsFallbackSchoolCoordinate,
  }) {
    final trimmedName = place.placeName?.trim();
    final trimmedCategory = place.category?.trim();
    final trimmedAddress = place.address?.trim();

    return PopularPlace(
      placeId: place.placeId,
      name: (trimmedName?.isNotEmpty ?? false)
          ? trimmedName!
          : '추천 장소 ${place.placeId}',
      category:
          (trimmedCategory?.isNotEmpty ?? false) ? trimmedCategory! : '장소',
      address: (trimmedAddress?.isNotEmpty ?? false)
          ? trimmedAddress!
          : fallbackAddress,
      review: place.reviewCount,
      recommended: place.recommendCount,
      isRecommended: place.recommended,
      coordinate: place.coordinate ?? fallbackCoordinate,
    );
  }
}

extension PopularPlaceDetailResolver on PopularPlace {
  PopularPlace resolveFromDetail(dynamic detail) {
    if (detail == null) return this;
    return copyWith(
      name: detail.placeName?.trim().isNotEmpty == true
          ? detail.placeName!.trim()
          : name,
      category: detail.category?.trim().isNotEmpty == true
          ? detail.category!.trim()
          : category,
      address: detail.address?.trim().isNotEmpty == true
          ? detail.address!.trim()
          : address,
      review: detail.reviewCount,
      recommended: detail.recommendCount,
      isRecommended: detail.recommended,
      coordinate: detail.coordinate ?? coordinate,
    );
  }
}
