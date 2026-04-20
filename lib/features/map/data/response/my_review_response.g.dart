// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_review_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyReviewResponse _$MyReviewResponseFromJson(Map<String, dynamic> json) =>
    _MyReviewResponse(
      reviewId: (json['reviewId'] as num).toInt(),
      placeId: (json['placeId'] as num).toInt(),
      placeName: json['placeName'] as String,
      categoryName: json['categoryName'] as String,
      address: json['address'] as String,
      content: json['content'] as String,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
    );
