class MapCoordinate {
  final double latitude;
  final double longitude;

  const MapCoordinate({
    required this.latitude,
    required this.longitude,
  });

  MapCoordinate copyWith({
    double? latitude,
    double? longitude,
  }) {
    return MapCoordinate(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, double> toJson() {
    return {'lat': latitude, 'lng': longitude};
  }
}

