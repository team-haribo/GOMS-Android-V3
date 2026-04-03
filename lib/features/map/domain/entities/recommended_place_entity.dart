import 'package:goms/features/map/data/models/map_coordinate.dart';

class RecommendedPlaceEntity {
  const RecommendedPlaceEntity({
    required this.placeId,
    required this.reviewCount,
    required this.recommendCount,
    required this.recommended,
    this.placeName,
    this.category,
    this.address,
    this.coordinate,
  });

  final int placeId;
  final int reviewCount;
  final int recommendCount;
  final bool recommended;
  final String? placeName;
  final String? category;
  final String? address;
  final MapCoordinate? coordinate;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is RecommendedPlaceEntity &&
        other.placeId == placeId &&
        other.reviewCount == reviewCount &&
        other.recommendCount == recommendCount &&
        other.recommended == recommended &&
        other.placeName == placeName &&
        other.category == category &&
        other.address == address &&
        other.coordinate == coordinate;
  }

  @override
  int get hashCode => Object.hash(
        placeId,
        reviewCount,
        recommendCount,
        recommended,
        placeName,
        category,
        address,
        coordinate,
      );
}
