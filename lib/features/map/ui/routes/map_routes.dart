import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_builders.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/map/direction/ui/screens/direction_screen.dart';
import 'package:goms/features/map/discovery/ui/screens/map_screen.dart';
import 'package:goms/features/map/review/ui/screens/write_review_screen.dart';
import 'package:goms/features/map/shared/ui/models/map_screen_type.dart';
import 'package:goms/features/map/shared/ui/screens/map_base_screen.dart';

List<RouteBase> buildMapRoutes() => [
      GoRoute(
        path: RoutePath.writeReview,
        name: 'writeReview',
        redirect: (context, state) =>
            redirectToMapIfPopularPlaceMissing(state.extra),
        builder: (context, state) => buildPopularPlaceRouteScreen(
          extra: state.extra,
          builder: (place) => WriteReviewScreen(
            placeId: place.placeId,
            placeName: place.name,
            category: place.category,
            address: place.address,
            review: place.review,
            recommended: place.recommended,
          ),
        ),
      ),
    ];

StatefulShellBranch buildMapShellBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: RoutePath.map,
        name: 'map',
        builder: (context, state) => const MapScreen(),
        routes: [
          GoRoute(
            path: 'direction',
            name: 'direction',
            builder: (context, state) => buildPopularPlaceRouteScreen(
              extra: state.extra,
              builder: (place) => DirectionScreen(place: place),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePath.mapDetail,
        name: 'mapDetail',
        builder: (context, state) => buildPopularPlaceRouteScreen(
          extra: state.extra,
          builder: (place) => MapBaseScreen(
            type: MapScreenType.detail,
            place: place,
          ),
        ),
      ),
    ],
  );
}
