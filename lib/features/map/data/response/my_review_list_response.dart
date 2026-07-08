import 'package:goms/features/map/data/response/my_review_response.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';

class MyReviewListResponse {
  const MyReviewListResponse({
    required this.reviews,
  });

  factory MyReviewListResponse.fromJson(Map<String, dynamic> json) {
    final values = json['reviews'] as List<dynamic>? ?? const <dynamic>[];

    return MyReviewListResponse(
      reviews: values
          .whereType<Map<String, dynamic>>()
          .map(MyReviewResponse.fromJson)
          .toList(growable: false),
    );
  }

  final List<MyReviewResponse> reviews;

  List<MyReviewEntity> toEntity() {
    return reviews.map((review) => review.toEntity()).toList(growable: false);
  }
}
