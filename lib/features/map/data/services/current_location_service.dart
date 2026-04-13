import 'package:geolocator/geolocator.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';

class CurrentLocationService {
  Future<MapCoordinate> getCurrentLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw const CurrentLocationException('위치 서비스가 꺼져 있습니다.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const CurrentLocationException('현재 위치 권한이 필요합니다.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

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
