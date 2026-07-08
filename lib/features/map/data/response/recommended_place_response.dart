import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommended_place_response.g.dart';

@JsonSerializable(createToJson: false)
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

  factory RecommendedPlaceResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedPlaceResponseFromJson(json);

  @JsonKey(defaultValue: 0, fromJson: _toInt)
  final int placeId;

  @JsonKey(defaultValue: 0, fromJson: _toInt)
  final int reviewCount;

  @JsonKey(defaultValue: 0, fromJson: _toInt)
  final int recommendCount;

  @JsonKey(defaultValue: false)
  final bool recommended;
  final String? placeName;

  @JsonKey(readValue: _readCategory)
  final String? category;

  @JsonKey(readValue: _readAddress)
  final String? address;

  @JsonKey(fromJson: _toNullableDouble)
  final double? latitude;

  @JsonKey(fromJson: _toNullableDouble)
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

Object? _readCategory(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['categoryGroupName'] ?? json['categoryName'];

Object? _readAddress(Map<dynamic, dynamic> json, String key) =>
    json['roadAddress'] ?? json[key];

int _toInt(num? value) => value?.toInt() ?? 0;

double? _toNullableDouble(num? value) => value?.toDouble();
