import 'package:json_annotation/json_annotation.dart';

part 'my_review_count_response.g.dart';

@JsonSerializable(createToJson: false)
class MyReviewCountResponse {
  const MyReviewCountResponse({
    required this.count,
  });

  factory MyReviewCountResponse.fromJson(Map<String, dynamic> json) =>
      _$MyReviewCountResponseFromJson(json);

  @JsonKey(defaultValue: 0, fromJson: _toInt)
  final int count;
}

int _toInt(num? value) => value?.toInt() ?? 0;
