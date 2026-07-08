import 'package:dio/dio.dart';
import 'package:goms/features/map/data/response/my_review_count_response.dart';
import 'package:goms/features/map/data/response/my_review_list_response.dart';
import 'package:goms/features/map/data/response/place_review_list_response.dart';
import 'package:goms/features/map/data/response/place_recommend_response.dart';
import 'package:goms/features/map/data/response/recommended_place_count_response.dart';
import 'package:goms/features/map/data/response/recommended_place_response.dart';
import 'package:goms/features/map/data/response/recommended_places_response.dart';
import 'package:retrofit/retrofit.dart';

part 'recommended_place_remote_datasource.g.dart';

@RestApi()
abstract class RecommendedPlaceRemoteDataSource {
  factory RecommendedPlaceRemoteDataSource(Dio dio, {String? baseUrl}) =
      _RecommendedPlaceRemoteDataSource;

  @GET('/api/v3/place')
  Future<RecommendedPlacesResponse> getPlaces();

  @GET('/api/v3/place/hot-place')
  Future<RecommendedPlacesResponse> getHotPlaces({
    @Query('days') int? days,
  });

  @GET('/api/v3/place/recommended')
  Future<RecommendedPlacesResponse> getRecommendedPlaces();

  @GET('/api/v3/place/recommended/count')
  Future<RecommendedPlaceCountResponse> getRecommendedPlacesCountRaw();

  @GET('/api/v3/place/search')
  Future<RecommendedPlacesResponse> searchPlaces(
    @Query('keyword') String keyword,
  );

  @GET('/api/v3/place/{placeId}')
  Future<RecommendedPlaceResponse> getPlaceDetail(@Path('placeId') int placeId);

  @GET('/api/v3/place/review/{placeId}')
  Future<PlaceReviewListResponse> getPlaceReviews(@Path('placeId') int placeId);

  @POST('/api/v3/place/recommend/{placeId}')
  Future<PlaceRecommendResponse> recommendPlaceRaw(
    @Path('placeId') int placeId,
  );

  @DELETE('/api/v3/place/recommend/{placeId}')
  Future<PlaceRecommendResponse> unRecommendPlaceRaw(
    @Path('placeId') int placeId,
  );

  @POST('/api/v3/review/{placeId}')
  Future<void> createReviewRaw(
    @Path('placeId') int placeId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/api/v3/review/me')
  Future<MyReviewListResponse> getMyReviews();

  @GET('/api/v3/review/count')
  Future<MyReviewCountResponse> getMyReviewCountRaw();

  @DELETE('/api/v3/review/{reviewId}')
  Future<void> deleteReview(@Path('reviewId') int reviewId);
}

extension RecommendedPlaceRemoteDataSourceX
    on RecommendedPlaceRemoteDataSource {
  Future<int> getRecommendedPlacesCount() async {
    final response = await getRecommendedPlacesCountRaw();
    return response.recommendCount;
  }

  Future<bool> recommendPlace(int placeId) async {
    final response = await recommendPlaceRaw(placeId);
    return response.recommended;
  }

  Future<bool> unRecommendPlace(int placeId) async {
    final response = await unRecommendPlaceRaw(placeId);
    return response.recommended;
  }

  Future<void> createReview({
    required int placeId,
    required String content,
  }) {
    return createReviewRaw(
      placeId,
      <String, dynamic>{'content': content},
    );
  }

  Future<int> getMyReviewCount() async {
    final response = await getMyReviewCountRaw();
    return response.count;
  }
}
