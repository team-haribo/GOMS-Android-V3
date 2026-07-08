// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_coordinate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapCoordinate _$MapCoordinateFromJson(Map<String, dynamic> json) =>
    _MapCoordinate(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$MapCoordinateToJson(_MapCoordinate instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
