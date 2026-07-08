import 'package:flutter/foundation.dart';

@immutable
class MapScreenReviewModel {
  final int reviewId;
  final String placeName;
  final String category;
  final String address;
  final String reviewDetailContent;
  final DateTime? createdAt;

  const MapScreenReviewModel({
    required this.reviewId,
    required this.placeName,
    required this.category,
    required this.address,
    required this.reviewDetailContent,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MapScreenReviewModel &&
            other.reviewId == reviewId &&
            other.placeName == placeName &&
            other.category == category &&
            other.address == address &&
            other.reviewDetailContent == reviewDetailContent &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
        reviewId,
        placeName,
        category,
        address,
        reviewDetailContent,
        createdAt,
      );
}
