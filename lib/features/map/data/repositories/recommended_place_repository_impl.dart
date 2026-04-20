import 'package:goms/features/map/data/datasources/recommended_place_remote_datasource.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';

class RecommendedPlaceRepositoryImpl implements RecommendedPlaceRepository {
  const RecommendedPlaceRepositoryImpl(this._remoteDataSource);

  final RecommendedPlaceRemoteDataSource _remoteDataSource;

  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async {
    final response = await _remoteDataSource.getPlaces();
    return response.toEntity();
  }

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async {
    final response = await _remoteDataSource.getHotPlaces(days: days);
    return response.toEntity();
  }

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async {
    final response = await _remoteDataSource.getRecommendedPlaces();
    return response.toEntity();
  }

  @override
  Future<int> getRecommendedPlacesCount() {
    return _remoteDataSource.getRecommendedPlacesCount();
  }

  @override
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword) async {
    final response = await _remoteDataSource.searchPlaces(keyword);
    return response.toEntity();
  }

  @override
  Future<RecommendedPlaceEntity> getPlaceDetail(int placeId) async {
    final response = await _remoteDataSource.getPlaceDetail(placeId);
    return response.toEntity();
  }

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async {
    final response = await _remoteDataSource.getPlaceReviews(placeId);
    return response.toEntity();
  }

  @override
  Future<bool> recommendPlace(int placeId) {
    return _remoteDataSource.recommendPlace(placeId);
  }

  @override
  Future<bool> unRecommendPlace(int placeId) {
    return _remoteDataSource.unRecommendPlace(placeId);
  }

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) {
    return _remoteDataSource.createReview(
      placeId: placeId,
      content: content,
    );
  }

  @override
  Future<List<MyReviewEntity>> getMyReviews() async {
    final response = await _remoteDataSource.getMyReviews();
    return response.toEntity();
  }

  @override
  Future<int> getMyReviewCount() {
    return _remoteDataSource.getMyReviewCount();
  }

  @override
  Future<void> deleteReview(int reviewId) {
    return _remoteDataSource.deleteReview(reviewId);
  }
}
