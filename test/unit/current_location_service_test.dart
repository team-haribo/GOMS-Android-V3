import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goms/features/map/data/services/current_location_service.dart';

void main() {
  group('CurrentLocationService', () {
    Position buildPosition({
      required double latitude,
      required double longitude,
    }) {
      return Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime(2026),
        accuracy: 1,
        altitude: 1,
        altitudeAccuracy: 1,
        heading: 1,
        headingAccuracy: 1,
        speed: 1,
        speedAccuracy: 1,
      );
    }

    test('returns last known location immediately when available', () async {
      var getCurrentPositionCalled = false;
      final service = CurrentLocationService(
        isLocationServiceEnabled: () async => true,
        checkPermission: () async => LocationPermission.always,
        requestPermission: () async => LocationPermission.always,
        getLastKnownPosition: () async => buildPosition(
          latitude: 35.123,
          longitude: 126.987,
        ),
        getCurrentPosition: ({locationSettings}) async {
          getCurrentPositionCalled = true;
          return buildPosition(latitude: 0, longitude: 0);
        },
      );

      final location = await service.getCachedOrCurrentLocation();

      expect(location.latitude, 35.123);
      expect(location.longitude, 126.987);
      expect(getCurrentPositionCalled, isFalse);
    });

    test('falls back to current position when no last known location exists',
        () async {
      final service = CurrentLocationService(
        isLocationServiceEnabled: () async => true,
        checkPermission: () async => LocationPermission.always,
        requestPermission: () async => LocationPermission.always,
        getLastKnownPosition: () async => null,
        getCurrentPosition: ({locationSettings}) async => buildPosition(
          latitude: 35.111,
          longitude: 126.222,
        ),
      );

      final location = await service.getCachedOrCurrentLocation();

      expect(location.latitude, 35.111);
      expect(location.longitude, 126.222);
    });
  });
}
