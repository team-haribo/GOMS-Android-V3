import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:goms/app/router/route_builders.dart';
import 'package:goms/app/router/route_path.dart';
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

  group('extraAsOrNull', () {
    test('returns null when extra type does not match', () {
      expect(extraAsOrNull<int>('invalid'), isNull);
    });

    test('returns typed value when extra type matches', () {
      expect(extraAsOrNull<int>(7), 7);
    });
  });

  group('route fallback builders', () {
    testWidgets('buildInvalidRouteAccessScreen shows invalid access message', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: buildInvalidRouteAccessScreen()),
      );

      expect(find.text('잘못된 접근입니다.'), findsOneWidget);
    });

    testWidgets(
        'buildPopularPlaceRouteScreen builds fallback for invalid extra', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: buildPopularPlaceRouteScreen(
            extra: 'invalid',
            builder: (_) => const SizedBox(),
          ),
        ),
      );

      expect(find.text('잘못된 접근입니다.'), findsOneWidget);
    });

    testWidgets(
        'buildPopularPlaceRouteScreen builds target widget for valid extra', (
      tester,
    ) async {
      const place = PopularPlace(
        placeId: 1,
        name: '학생식당',
        category: '한식',
        address: '광주광역시',
        review: 2,
        recommended: 3,
        coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: buildPopularPlaceRouteScreen(
            extra: place,
            builder: (value) =>
                Text(value.name, textDirection: TextDirection.ltr),
          ),
        ),
      );

      expect(find.text('학생식당'), findsOneWidget);
    });
  });
}
