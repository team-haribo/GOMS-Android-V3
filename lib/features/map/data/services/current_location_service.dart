import 'package:geolocator/geolocator.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';

typedef IsLocationServiceEnabled = Future<bool> Function();
typedef CheckPermission = Future<LocationPermission> Function();
typedef RequestPermission = Future<LocationPermission> Function();
typedef GetLastKnownPosition = Future<Position?> Function();
typedef GetCurrentPosition = Future<Position> Function({
  LocationSettings? locationSettings,
});

class CurrentLocationService {
  CurrentLocationService({
    IsLocationServiceEnabled? isLocationServiceEnabled,
    CheckPermission? checkPermission,
    RequestPermission? requestPermission,
    GetLastKnownPosition? getLastKnownPosition,
    GetCurrentPosition? getCurrentPosition,
  })  : _isLocationServiceEnabled =
            isLocationServiceEnabled ?? Geolocator.isLocationServiceEnabled,
        _checkPermission = checkPermission ?? Geolocator.checkPermission,
        _requestPermission = requestPermission ?? Geolocator.requestPermission,
        _getLastKnownPosition =
            getLastKnownPosition ?? Geolocator.getLastKnownPosition,
        _getCurrentPosition =
            getCurrentPosition ?? Geolocator.getCurrentPosition;

  final IsLocationServiceEnabled _isLocationServiceEnabled;
  final CheckPermission _checkPermission;
  final RequestPermission _requestPermission;
  final GetLastKnownPosition _getLastKnownPosition;
  final GetCurrentPosition _getCurrentPosition;

  Future<MapCoordinate> getCurrentLocation() async {
    await _ensureLocationPermission();

    final position = await _getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return _toMapCoordinate(position);
  }

  Future<MapCoordinate> getCachedOrCurrentLocation() async {
    await _ensureLocationPermission();

    final lastKnownPosition = await _getLastKnownPosition();
    if (lastKnownPosition != null) {
      return _toMapCoordinate(lastKnownPosition);
    }

    return getCurrentLocation();
  }

  Future<void> _ensureLocationPermission() async {
    final isServiceEnabled = await _isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw const CurrentLocationException('위치 서비스가 꺼져 있습니다.');
    }

    var permission = await _checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const CurrentLocationException('현재 위치 권한이 필요합니다.');
    }
  }

  MapCoordinate _toMapCoordinate(Position position) {
    return MapCoordinate(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

class CurrentLocationException implements Exception {
  final String message;

  const CurrentLocationException(this.message);

  @override
  String toString() => message;
}
