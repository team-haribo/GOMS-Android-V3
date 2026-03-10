import 'package:flutter/material.dart';
import 'package:project_setting/presentation/map/base/models/map_screen_type.dart';
import 'package:project_setting/presentation/map/base/screens/map_base_screen.dart';
import 'package:project_setting/presentation/map/main/models/popular_place.dart';

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
