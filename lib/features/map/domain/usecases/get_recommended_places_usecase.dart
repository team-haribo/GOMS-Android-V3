import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';

class GetRecommendedPlacesUseCase {
  const GetRecommendedPlacesUseCase(this._repository);

  final RecommendedPlaceRepository _repository;

  Future<List<RecommendedPlaceEntity>> call() {
    return _repository.getRecommendedPlaces();
  }
}
