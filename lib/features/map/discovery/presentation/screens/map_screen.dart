import 'package:flutter/material.dart';
import 'package:goms/features/map/shared/presentation/screens/map_base_screen.dart';
import 'package:goms/features/map/shared/presentation/models/map_screen_type.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapBaseScreen(
      type: MapScreenType.main,
    );
  }
}
