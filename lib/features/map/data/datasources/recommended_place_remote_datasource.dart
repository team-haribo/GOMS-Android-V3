import 'package:dio/dio.dart';
import 'package:goms/features/map/data/response/place_review_list_response.dart';
import 'package:goms/features/map/data/response/recommended_place_response.dart';
import 'package:goms/features/map/data/response/recommended_places_response.dart';

class RecommendedPlaceRemoteDataSource {
  const RecommendedPlaceRemoteDataSource(this._dio);

  final Dio _dio;

  Future<RecommendedPlacesResponse> getPlaces() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place',
    );
    return RecommendedPlacesResponse.fromJson(response.data ?? const {});
  }

  Future<RecommendedPlacesResponse> getHotPlaces({int? days}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place/hot-place',
      queryParameters: days == null ? null : {'days': days},
    );
    return RecommendedPlacesResponse.fromJson(response.data ?? const {});
  }

  Future<RecommendedPlacesResponse> getRecommendedPlaces() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place/recommended',
    );
    return RecommendedPlacesResponse.fromJson(response.data ?? const {});
  }

  Future<int> getRecommendedPlacesCount() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place/recommended/count',
    );
    return (response.data?['recommendCount'] as num?)?.toInt() ?? 0;
  }

  Future<RecommendedPlacesResponse> searchPlaces(String keyword) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place/search',
      queryParameters: {'keyword': keyword},
    );
    return RecommendedPlacesResponse.fromJson(response.data ?? const {});
  }

  Future<RecommendedPlaceResponse> getPlaceDetail(int placeId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place/$placeId',
    );
    return RecommendedPlaceResponse.fromJson(response.data ?? const {});
  }

  Future<PlaceReviewListResponse> getPlaceReviews(int placeId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place/review/$placeId',
    );
    return PlaceReviewListResponse.fromJson(response.data ?? const {});
  }

  Future<bool> recommendPlace(int placeId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v3/place/recommend/$placeId',
    );
    return response.data?['recommended'] as bool? ?? true;
  }

  Future<bool> unRecommendPlace(int placeId) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '/api/v3/place/recommend/$placeId',
    );
    return response.data?['recommended'] as bool? ?? false;
  }

  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/v3/review/$placeId',
      data: {'content': content},
    );
  }
}
