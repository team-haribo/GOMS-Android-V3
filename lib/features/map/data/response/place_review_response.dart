import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';

part 'place_review_response.g.dart';

@JsonSerializable(createToJson: false)
class PlaceReviewResponse {
  const PlaceReviewResponse({
    required this.reviewId,
    required this.name,
    required this.grade,
    required this.department,
    required this.profileImageUrl,
    required this.content,
    required this.reviewedAt,
  });

  factory PlaceReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceReviewResponseFromJson(json);

  @JsonKey(name: 'review_id', defaultValue: 0, fromJson: _toInt)
  final int reviewId;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: 0, fromJson: _toInt)
  final int grade;

  @JsonKey(defaultValue: '')
  final String department;

  @JsonKey(defaultValue: '')
  final String profileImageUrl;

  @JsonKey(defaultValue: '')
  final String content;

  @JsonKey(name: 'reviewed_at', fromJson: _toNullableDateTime)
  final DateTime? reviewedAt;

  PlaceReviewEntity toEntity() {
    return PlaceReviewEntity(
      reviewId: reviewId,
      name: name,
      grade: grade,
      department: department,
      profileImageUrl: profileImageUrl,
      content: content,
      reviewedAt: reviewedAt,
    );
  }
}

int _toInt(num? value) => value?.toInt() ?? 0;

DateTime? _toNullableDateTime(String? value) => DateTime.tryParse(value ?? '');
