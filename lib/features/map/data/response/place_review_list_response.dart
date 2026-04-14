import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/map/data/response/place_review_response.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';

part 'place_review_list_response.g.dart';

@JsonSerializable(createToJson: false)
class PlaceReviewListResponse {
  const PlaceReviewListResponse({
    required this.reviews,
  });

  factory PlaceReviewListResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceReviewListResponseFromJson(json);

  @JsonKey(defaultValue: <PlaceReviewResponse>[], fromJson: _reviewsFromJson)
  final List<PlaceReviewResponse> reviews;

  List<PlaceReviewEntity> toEntity() {
    return reviews.map((review) => review.toEntity()).toList(growable: false);
  }
}

List<PlaceReviewResponse> _reviewsFromJson(List<dynamic>? values) =>
    (values ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(PlaceReviewResponse.fromJson)
        .toList(growable: false);
