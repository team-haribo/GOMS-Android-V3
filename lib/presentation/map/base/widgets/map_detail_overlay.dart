import 'package:flutter/material.dart';
import 'package:project_setting/presentation/map/main/models/map_page_state.dart';
import 'package:project_setting/presentation/map/main/models/popular_place.dart';

class MapDetailOverlay extends StatelessWidget {
  final PopularPlace place;
  final MapPageState state;

  const MapDetailOverlay({
    super.key,
    required this.place,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
