import 'package:dio/dio.dart';
import 'package:goms/features/map/data/response/recommended_places_response.dart';

class RecommendedPlaceRemoteDataSource {
  const RecommendedPlaceRemoteDataSource(this._dio);

  final Dio _dio;

  Future<RecommendedPlacesResponse> getRecommendedPlaces() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/place/recommended',
    );
    return RecommendedPlacesResponse.fromJson(response.data ?? const {});
  }
}
