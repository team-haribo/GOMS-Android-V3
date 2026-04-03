import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';

abstract class RecommendedPlaceRepository {
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces();
}
