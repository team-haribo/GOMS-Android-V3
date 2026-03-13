import 'package:flutter/material.dart';
import 'package:goms/features/map/presentation/pages/base/models/map_screen_type.dart';
import 'package:goms/features/map/presentation/pages/base/map_base_screen.dart';
import 'package:goms/features/map/presentation/pages/main/models/popular_place.dart';

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




