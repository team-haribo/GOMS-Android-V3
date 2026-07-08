import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/map/data/response/recommended_place_response.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

part 'recommended_places_response.g.dart';

@JsonSerializable(createToJson: false)
class RecommendedPlacesResponse {
  const RecommendedPlacesResponse({
    required this.places,
  });

  factory RecommendedPlacesResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedPlacesResponseFromJson(json);

  @JsonKey(
    defaultValue: <RecommendedPlaceResponse>[],
    fromJson: _placesFromJson,
  )
  final List<RecommendedPlaceResponse> places;

  List<RecommendedPlaceEntity> toEntity() {
    return places.map((place) => place.toEntity()).toList();
  }
}

List<RecommendedPlaceResponse> _placesFromJson(List<dynamic>? values) =>
    (values ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(RecommendedPlaceResponse.fromJson)
        .toList(growable: false);
