import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

abstract class RecommendedPlaceRepository {
  Future<List<RecommendedPlaceEntity>> getPlaces();
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days});
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces();
  Future<int> getRecommendedPlacesCount();
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword);
  Future<RecommendedPlaceEntity> getPlaceDetail(int placeId);
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId);
  Future<bool> recommendPlace(int placeId);
  Future<bool> unRecommendPlace(int placeId);
  Future<void> createReview({
    required int placeId,
    required String content,
  });
  Future<List<MyReviewEntity>> getMyReviews();
  Future<int> getMyReviewCount();
  Future<void> deleteReview(int reviewId);
}
