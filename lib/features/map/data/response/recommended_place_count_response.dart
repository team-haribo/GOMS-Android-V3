import 'package:json_annotation/json_annotation.dart';

part 'recommended_place_count_response.g.dart';

@JsonSerializable(createToJson: false)
class RecommendedPlaceCountResponse {
  const RecommendedPlaceCountResponse({
    required this.recommendCount,
  });

  factory RecommendedPlaceCountResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedPlaceCountResponseFromJson(json);

  @JsonKey(defaultValue: 0, fromJson: _toInt)
  final int recommendCount;
}

int _toInt(num? value) => value?.toInt() ?? 0;
