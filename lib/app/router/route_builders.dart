import 'package:flutter/material.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';

const invalidRouteAccessMessage = '잘못된 접근입니다.';

String? redirectToMapIfPopularPlaceMissing(Object? extra) {
  if (extra is! PopularPlace) {
    return RoutePath.map;
  }
  return null;
}

Widget buildInvalidRouteAccessScreen() {
  return const Scaffold(
    body: Center(child: Text(invalidRouteAccessMessage)),
  );
}

T? extraAsOrNull<T>(Object? extra) => extra is T ? extra : null;

Widget buildPopularPlaceRouteScreen({
  required Object? extra,
  required Widget Function(PopularPlace place) builder,
}) {
  final place = extraAsOrNull<PopularPlace>(extra);
  if (place == null) {
    return buildInvalidRouteAccessScreen();
  }
  return builder(place);
}
