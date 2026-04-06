import 'package:goms/features/map/data/response/recommended_place_response.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

class RecommendedPlacesResponse {
  const RecommendedPlacesResponse({
    required this.places,
  });

  factory RecommendedPlacesResponse.fromJson(Map<String, dynamic> json) {
    final places = (json['places'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(RecommendedPlaceResponse.fromJson)
        .toList();

    return RecommendedPlacesResponse(places: places);
  }

  final List<RecommendedPlaceResponse> places;

  List<RecommendedPlaceEntity> toEntity() {
    return places.map((place) => place.toEntity()).toList();
  }
}
