import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';

part 'recommended_place_entity.freezed.dart';

@freezed
abstract class RecommendedPlaceEntity with _$RecommendedPlaceEntity {
  const factory RecommendedPlaceEntity({
    required int placeId,
    required int reviewCount,
    required int recommendCount,
    required bool recommended,
    String? placeName,
    String? category,
    String? address,
    MapCoordinate? coordinate,
  }) = _RecommendedPlaceEntity;
}
