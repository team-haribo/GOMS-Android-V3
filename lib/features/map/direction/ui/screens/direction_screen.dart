import 'package:flutter/material.dart';
import 'package:goms/features/map/shared/ui/models/map_screen_type.dart';
import 'package:goms/features/map/shared/ui/screens/map_base_screen.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';

class DirectionScreen extends StatelessWidget {
  final PopularPlace place;
  final bool startAsDeparture;

  const DirectionScreen({
    super.key,
    required this.place,
    this.startAsDeparture = false,
  });

  @override
  Widget build(BuildContext context) {
    return MapBaseScreen(
      type: MapScreenType.direction,
      place: place,
      startAsDeparture: startAsDeparture,
    );
  }
}
