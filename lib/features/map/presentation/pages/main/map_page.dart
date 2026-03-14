import 'package:flutter/material.dart';
import 'package:goms/features/map/presentation/pages/base/models/map_screen_type.dart';
import 'package:goms/features/map/presentation/pages/base/map_base_screen.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapBaseScreen(
      type: MapScreenType.main,
    );
  }
}




