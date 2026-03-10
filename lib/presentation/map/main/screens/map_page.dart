import 'package:flutter/material.dart';
import 'package:project_setting/presentation/map/base/models/map_screen_type.dart';
import 'package:project_setting/presentation/map/base/screens/map_base_screen.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapBaseScreen(
      type: MapScreenType.main,
    );
  }
}
