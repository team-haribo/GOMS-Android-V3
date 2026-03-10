import 'package:flutter/material.dart';
import 'package:project_setting/presentation/map/main/models/popular_place.dart';

class KakaoMapBackground extends StatelessWidget {
  final PopularPlace? focusPlace;
  final bool showRoutePreview;

  const KakaoMapBackground({
    super.key,
    this.focusPlace,
    this.showRoutePreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
