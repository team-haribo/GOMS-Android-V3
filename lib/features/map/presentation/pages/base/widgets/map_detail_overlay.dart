import 'package:flutter/material.dart';
import 'package:goms/features/map/presentation/pages/main/models/map_page_state.dart';
import 'package:goms/features/map/presentation/pages/main/models/popular_place.dart';

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


