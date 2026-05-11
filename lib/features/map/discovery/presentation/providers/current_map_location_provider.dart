import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/services/map_service_providers.dart';

final currentMapLocationProvider = FutureProvider<MapCoordinate?>((ref) async {
  try {
    return await ref
        .read(currentLocationServiceProvider)
        .getCachedOrCurrentLocation();
  } catch (_) {
    return null;
  }
});
