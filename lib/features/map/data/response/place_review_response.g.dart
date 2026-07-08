// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_review_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceReviewResponse _$PlaceReviewResponseFromJson(Map<String, dynamic> json) =>
    PlaceReviewResponse(
      reviewId:
          json['review_id'] == null ? 0 : _toInt(json['review_id'] as num?),
      name: json['name'] as String? ?? '',
      grade: json['grade'] == null ? 0 : _toInt(json['grade'] as num?),
      department: json['department'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      content: json['content'] as String? ?? '',
      reviewedAt: _toNullableDateTime(json['reviewed_at'] as String?),
    );
