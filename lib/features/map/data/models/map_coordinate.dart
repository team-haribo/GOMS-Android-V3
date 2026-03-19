import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

part 'map_coordinate.freezed.dart';
part 'map_coordinate.g.dart';

@freezed
abstract class MapCoordinate with _$MapCoordinate {
  const factory MapCoordinate({
    required double latitude,
    required double longitude,
  }) = _MapCoordinate;

  factory MapCoordinate.fromKakaoLatLng(kakao.LatLng latLng) => MapCoordinate(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );

  factory MapCoordinate.fromJson(Map<String, dynamic> json) =>
      _$MapCoordinateFromJson(json);
}
