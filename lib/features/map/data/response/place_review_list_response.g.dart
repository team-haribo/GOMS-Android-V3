// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_review_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceReviewListResponse _$PlaceReviewListResponseFromJson(
        Map<String, dynamic> json) =>
    PlaceReviewListResponse(
      reviews: json['reviews'] == null
          ? []
          : _reviewsFromJson(json['reviews'] as List?),
    );
