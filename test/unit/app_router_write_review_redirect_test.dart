import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/router/app_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';

void main() {
  group('redirectToMapIfPopularPlaceMissing', () {
    test('returns map path when extra is null', () {
      expect(redirectToMapIfPopularPlaceMissing(null), RoutePath.map);
    });

    test('returns map path when extra has unexpected type', () {
      expect(redirectToMapIfPopularPlaceMissing('invalid'), RoutePath.map);
    });

    test('returns null when extra is PopularPlace', () {
      const place = PopularPlace(
        placeId: 1,
        name: '학생식당',
        category: '한식',
        address: '광주광역시',
        review: 2,
        recommended: 3,
        coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
      );

      expect(redirectToMapIfPopularPlaceMissing(place), isNull);
    });
  });
}
