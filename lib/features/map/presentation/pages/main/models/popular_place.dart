import 'package:goms/features/map/models/map_coordinate.dart';

class PopularPlace {
  final String name;
  final String category;
  final String address;
  final int review;
  final int recommended;
  final int? distanceMeters;
  final MapCoordinate coordinate;

  const PopularPlace({
    required this.name,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
    required this.coordinate,
    this.distanceMeters,
  });
}

