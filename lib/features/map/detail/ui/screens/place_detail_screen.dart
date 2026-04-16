import 'package:flutter/material.dart';
import 'package:goms/features/map/shared/ui/models/map_screen_type.dart';
import 'package:goms/features/map/shared/ui/screens/map_base_screen.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';

class PlaceDetailScreen extends StatelessWidget {
  final PopularPlace place;

  const PlaceDetailScreen({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return MapBaseScreen(
      type: MapScreenType.detail,
      place: place,
    );
  }
}
