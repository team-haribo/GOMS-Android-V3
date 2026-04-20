import 'package:json_annotation/json_annotation.dart';

part 'place_recommend_response.g.dart';

@JsonSerializable(createToJson: false)
class PlaceRecommendResponse {
  const PlaceRecommendResponse({
    required this.recommended,
  });

  factory PlaceRecommendResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceRecommendResponseFromJson(json);

  @JsonKey(defaultValue: false)
  final bool recommended;
}
