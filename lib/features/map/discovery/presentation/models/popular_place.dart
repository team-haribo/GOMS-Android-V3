import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';

part 'popular_place.freezed.dart';

@freezed
abstract class PopularPlace with _$PopularPlace {
  const factory PopularPlace({
    int? placeId,
    required String name,
    required String category,
    required String address,
    required int review,
    required int recommended,
    @Default(false) bool isRecommended,
    int? distanceMeters,
    required MapCoordinate coordinate,
  }) = _PopularPlace;
}
