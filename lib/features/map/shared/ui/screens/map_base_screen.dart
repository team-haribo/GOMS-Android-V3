import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/map/shared/ui/models/map_screen_type.dart';
import 'package:goms/features/map/shared/ui/widgets/map_detail_overlay.dart';
import 'package:goms/features/map/shared/ui/widgets/map_direction_overlay.dart';
import 'package:goms/features/map/shared/ui/widgets/map_main_overlay.dart';
import 'package:goms/features/map/shared/ui/widgets/map_scaffold.dart';
import 'package:goms/features/map/direction/ui/models/direction_state.dart';
import 'package:goms/features/map/direction/ui/providers/direction_provider.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/discovery/ui/providers/current_map_location_provider.dart';
import 'package:goms/features/map/discovery/ui/providers/map_screen_provider.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/shared/ui/widgets/kakao_map_background.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

class MapBaseScreen extends ConsumerStatefulWidget {
  final MapScreenType type;
  final PopularPlace? place;

  const MapBaseScreen({
    super.key,
    required this.type,
    this.place,
  });

  @override
  ConsumerState<MapBaseScreen> createState() => _MapBaseScreenState();
}

class _MapBaseScreenState extends ConsumerState<MapBaseScreen> {
  static const double _mapTapMatchRadiusMeters = 20;

  PopularPlace? _selectedPlace;
  bool _didRequestInitialMapFetch = false;

  @override
  void initState() {
    super.initState();
    _scheduleInitialMapFetch();
    _syncDirectionDestination();
  }

  @override
  void didUpdateWidget(covariant MapBaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.place?.name != widget.place?.name ||
        oldWidget.type != widget.type) {
      _scheduleInitialMapFetch();
      _syncDirectionDestination();
    }
  }

  void _scheduleInitialMapFetch() {
    if (_didRequestInitialMapFetch) {
      return;
    }

    if (widget.type != MapScreenType.main &&
        widget.type != MapScreenType.detail) {
      return;
    }

    _didRequestInitialMapFetch = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(mapScreenProvider.notifier).fetchData();
    });
  }

  void _syncDirectionDestination() {
    if (widget.type != MapScreenType.direction || widget.place == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.place == null) {
        return;
      }
      ref.read(directionProvider.notifier).setDestination(widget.place!);
    });
  }

  void _selectPlace(PopularPlace place) {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedPlace = place;
    });
  }

  void _handleMapTap(
    MapCoordinate coordinate,
    List<PopularPlace> candidatePlaces,
  ) {
    if (widget.type != MapScreenType.main) {
      return;
    }

    final matchedPlace = findNearestPlaceWithinRadius(
      tapCoordinate: coordinate,
      places: candidatePlaces,
      maxDistanceMeters: _mapTapMatchRadiusMeters,
    );
    if (matchedPlace == null) {
      return;
    }

    _selectPlace(matchedPlace);
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final mapState = ref.watch(mapScreenProvider);
    final directionState = ref.watch(directionProvider);
    final searchKeyword = ref.watch(placeSearchKeywordProvider);
    final searchResults = ref.watch(placeSearchResultsProvider).asData?.value;
    final allPlaces = ref.watch(allPlacesProvider).asData?.value;
    final currentLocation = ref.watch(currentMapLocationProvider).asData?.value;

    if (widget.type != MapScreenType.main && place == null) {
      return const MapScaffold(
        body: Center(child: Text('선택된 장소가 없습니다.')),
      );
    }

    if (widget.type == MapScreenType.main ||
        widget.type == MapScreenType.detail) {
      ref.listen<MapScreenState>(mapScreenProvider, (previous, next) {
        if (!mounted) {
          return;
        }
        if (next.status == MapScreenStatus.failure &&
            next.errorMessage != null) {
          final message = next.errorMessage!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            ref.read(mapScreenProvider.notifier).clearError();
            _showError(message);
          });
        }
      });
    }

    if (widget.type == MapScreenType.direction) {
      ref.listen<DirectionState>(directionProvider, (previous, next) {
        if (!mounted) {
          return;
        }
        if (next.status == DirectionStatus.failure &&
            next.errorMessage != null) {
          final message = next.errorMessage!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            ref.read(directionProvider.notifier).clearError();
            _showError(message);
          });
        }
      });
    }

    final routePath = widget.type == MapScreenType.direction &&
            directionState.routeOptions.isNotEmpty
        ? directionState.routeOptions[directionState.selectedRouteIndex].path
        : const <MapCoordinate>[];

    final searchedPlaces =
        (searchKeyword.trim().isNotEmpty ? searchResults ?? const [] : const [])
            .map((place) => _toPopularPlace(place))
            .toList(growable: false);
    final markerPlaces = (allPlaces ?? const <RecommendedPlaceEntity>[])
        .map((place) => _toPopularPlace(place))
        .toList(growable: false);
    final candidatePlaces = resolveCandidatePlaces(
      type: widget.type,
      routePlace: place,
      searchedPlaces: searchedPlaces,
      markerPlaces: markerPlaces,
      popularPlaces: mapState.popularPlaces,
    );
    final selectedPlace = _resolveSelectedPlace(candidatePlaces);
    final places = resolveVisiblePlaces(
      type: widget.type,
      routePlace: place,
      selectedPlace: selectedPlace,
      popularPlaces: mapState.popularPlaces,
    );

    return MapScaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: KakaoMapBackground(
              places: places,
              focusPlace: place,
              routePath: routePath,
              showRoutePreview: widget.type == MapScreenType.direction,
              preserveZoomLevelOnSinglePlaceSelection:
                  widget.type == MapScreenType.main,
              currentLocation: currentLocation,
              preferCurrentLocation: widget.type == MapScreenType.main,
              showCurrentLocationLabel: widget.type != MapScreenType.main,
              onPlaceTap: _selectPlace,
              onMapTap: (coordinate) => _handleMapTap(
                coordinate,
                candidatePlaces,
              ),
            ),
          ),
          Positioned.fill(
            child: _buildOverlay(
              place,
              mapState,
              directionState,
              selectedPlace,
            ),
          ),
        ],
      ),
    );
  }

  PopularPlace? _resolveSelectedPlace(List<PopularPlace> places) {
    final selectedPlace = _selectedPlace;
    if (widget.type != MapScreenType.main || selectedPlace == null) {
      return selectedPlace;
    }

    for (final place in places) {
      if (_isSamePlace(place, selectedPlace)) {
        return place;
      }
    }

    return selectedPlace;
  }

  bool _isSamePlace(PopularPlace a, PopularPlace b) {
    if (a.placeId != null && b.placeId != null) {
      return a.placeId == b.placeId;
    }

    return a.name == b.name && a.address == b.address;
  }

  Widget _buildOverlay(
    PopularPlace? place,
    MapScreenState mapState,
    DirectionState directionState,
    PopularPlace? selectedPlace,
  ) {
    final overlay = switch (widget.type) {
      MapScreenType.main => MapMainOverlay(
          state: mapState,
          selectedPlace: selectedPlace,
          onPlaceTap: _selectPlace,
          onSelectedPlaceDismiss: () {
            if (!mounted) {
              return;
            }
            setState(() {
              _selectedPlace = null;
            });
          },
        ),
      MapScreenType.detail => MapDetailOverlay(place: place!, state: mapState),
      MapScreenType.direction => MapDirectionOverlay(
          place: place!,
          state: directionState,
          onSwap: () => ref.read(directionProvider.notifier).swapLocations(),
          onSelect: (index) =>
              ref.read(directionProvider.notifier).selectRoute(index),
          onDepartureSelect: (value) =>
              ref.read(directionProvider.notifier).selectDeparture(value),
        ),
    };

    if (widget.type == MapScreenType.direction) {
      return overlay;
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s16),
        child: overlay,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.negative,
      ),
    );
  }
}

List<PopularPlace> resolveCandidatePlaces({
  required MapScreenType type,
  required PopularPlace? routePlace,
  required List<PopularPlace> searchedPlaces,
  required List<PopularPlace> markerPlaces,
  required List<PopularPlace> popularPlaces,
}) {
  return switch (type) {
    MapScreenType.main => searchedPlaces.isNotEmpty
        ? searchedPlaces
        : (markerPlaces.isNotEmpty ? markerPlaces : popularPlaces),
    _ => routePlace == null ? popularPlaces : [routePlace],
  };
}

List<PopularPlace> resolveVisiblePlaces({
  required MapScreenType type,
  required PopularPlace? routePlace,
  required PopularPlace? selectedPlace,
  required List<PopularPlace> popularPlaces,
}) {
  return switch (type) {
    MapScreenType.main => selectedPlace == null ? const [] : [selectedPlace],
    _ => routePlace == null ? popularPlaces : [routePlace],
  };
}

PopularPlace? findNearestPlaceWithinRadius({
  required MapCoordinate tapCoordinate,
  required List<PopularPlace> places,
  required double maxDistanceMeters,
}) {
  PopularPlace? nearestPlace;
  double? nearestDistance;
  final tapLatLng = kakao.LatLng(
    tapCoordinate.latitude,
    tapCoordinate.longitude,
  );

  for (final place in places) {
    final placeLatLng = kakao.LatLng(
      place.coordinate.latitude,
      place.coordinate.longitude,
    );
    final distance = tapLatLng.distance(placeLatLng);
    if (distance > maxDistanceMeters) {
      continue;
    }
    if (nearestDistance == null || distance < nearestDistance) {
      nearestPlace = place;
      nearestDistance = distance;
    }
  }

  return nearestPlace;
}

PopularPlace _toPopularPlace(RecommendedPlaceEntity place) {
  return PopularPlace.fromRecommendedPlace(
    place,
    fallbackCoordinate: gomsFallbackSchoolCoordinate,
  );
}
