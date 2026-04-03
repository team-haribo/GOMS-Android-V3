import 'package:goms/features/map/data/datasources/recommended_place_remote_datasource.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';

class RecommendedPlaceRepositoryImpl implements RecommendedPlaceRepository {
  const RecommendedPlaceRepositoryImpl(this._remoteDataSource);

  final RecommendedPlaceRemoteDataSource _remoteDataSource;

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async {
    final response = await _remoteDataSource.getRecommendedPlaces();
    return response.toEntity();
  }
}
