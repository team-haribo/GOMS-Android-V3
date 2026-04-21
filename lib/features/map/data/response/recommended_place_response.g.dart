// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_place_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedPlaceResponse _$RecommendedPlaceResponseFromJson(
        Map<String, dynamic> json) =>
    RecommendedPlaceResponse(
      placeId: json['placeId'] == null ? 0 : _toInt(json['placeId'] as num?),
      reviewCount:
          json['reviewCount'] == null ? 0 : _toInt(json['reviewCount'] as num?),
      recommendCount: json['recommendCount'] == null
          ? 0
          : _toInt(json['recommendCount'] as num?),
      recommended: json['recommended'] as bool? ?? false,
      placeName: json['placeName'] as String?,
      category: _readCategory(json, 'category') as String?,
      address: _readAddress(json, 'address') as String?,
      latitude: _toNullableDouble(json['latitude'] as num?),
      longitude: _toNullableDouble(json['longitude'] as num?),
    );
