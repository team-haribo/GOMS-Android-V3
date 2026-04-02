import 'package:flutter/material.dart';
import 'package:goms/features/map/shared/presentation/models/map_screen_type.dart';
import 'package:goms/features/map/shared/presentation/screens/map_base_screen.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';

class DirectionScreen extends StatelessWidget {
  final PopularPlace place;

  const DirectionScreen({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return MapBaseScreen(
      type: MapScreenType.direction,
      place: place,
    );
  }
}
