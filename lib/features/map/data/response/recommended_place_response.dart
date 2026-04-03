import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

class RecommendedPlaceResponse {
  const RecommendedPlaceResponse({
    required this.placeId,
    required this.reviewCount,
    required this.recommendCount,
    required this.recommended,
    this.placeName,
    this.category,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory RecommendedPlaceResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedPlaceResponse(
      placeId: (json['placeId'] as num?)?.toInt() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      recommendCount: (json['recommendCount'] as num?)?.toInt() ?? 0,
      recommended: json['recommended'] as bool? ?? false,
      placeName: json['placeName'] as String?,
      category: json['category'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  final int placeId;
  final int reviewCount;
  final int recommendCount;
  final bool recommended;
  final String? placeName;
  final String? category;
  final String? address;
  final double? latitude;
  final double? longitude;

  RecommendedPlaceEntity toEntity() {
    final coordinate = latitude != null && longitude != null
        ? MapCoordinate(latitude: latitude!, longitude: longitude!)
        : null;

    return RecommendedPlaceEntity(
      placeId: placeId,
      reviewCount: reviewCount,
      recommendCount: recommendCount,
      recommended: recommended,
      placeName: placeName,
      category: category,
      address: address,
      coordinate: coordinate,
    );
  }
}
