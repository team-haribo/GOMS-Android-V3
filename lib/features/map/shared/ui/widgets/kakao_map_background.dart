import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/kakao_map_runtime.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/shared/ui/providers/kakao_map_background_provider.dart';
import 'package:goms/features/map/shared/ui/models/map_poi_marker_asset.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

class KakaoMapBackground extends ConsumerStatefulWidget {
  final List<PopularPlace> places;
  final PopularPlace? focusPlace;
  final List<MapCoordinate> routePath;
  final bool showRoutePreview;
  final MapCoordinate? currentLocation;
  final bool preferCurrentLocation;
  final ValueChanged<PopularPlace>? onPlaceTap;

  const KakaoMapBackground({
    super.key,
    this.places = const <PopularPlace>[],
    this.focusPlace,
    this.routePath = const <MapCoordinate>[],
    this.showRoutePreview = false,
    this.currentLocation,
    this.preferCurrentLocation = false,
    this.onPlaceTap,
  });

  @override
  ConsumerState<KakaoMapBackground> createState() => _KakaoMapBackgroundState();
}

class _KakaoMapBackgroundState extends ConsumerState<KakaoMapBackground> {
  kakao.KakaoMapController? _controller;
  final List<kakao.Poi> _pois = <kakao.Poi>[];
  kakao.Route? _route;
  int _renderToken = 0;

  String get _mapId =>
      '${widget.focusPlace?.name}|${widget.focusPlace?.address}|${widget.places.length}|${widget.routePath.length}|${widget.currentLocation?.latitude}|${widget.currentLocation?.longitude}|${widget.preferCurrentLocation}';

  @override
  void didUpdateWidget(covariant KakaoMapBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusPlace?.name != widget.focusPlace?.name ||
        oldWidget.focusPlace?.address != widget.focusPlace?.address ||
        oldWidget.places.length != widget.places.length ||
        oldWidget.routePath.length != widget.routePath.length) {
      ref
          .read(kakaoMapBackgroundControllerProvider(_mapId).notifier)
          .setController(_controller);
    }
    if (KakaoMapRuntime.instance.isMapAvailable) {
      _renderMapObjects();
    }
  }

  Future<void> _renderMapObjects() async {
    final controller = _controller;
    if (controller == null || !KakaoMapRuntime.instance.isMapAvailable) {
      return;
    }

    final token = ++_renderToken;

    try {
      await _clearOverlays(controller);
      if (!mounted || token != _renderToken) {
        return;
      }

      final cameraPoints = <kakao.LatLng>[];
      final renderPlaces = _buildRenderPlaces();
      final currentLocation = widget.currentLocation;

      if (currentLocation != null) {
        final currentLatLng = kakao.LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        );
        if (widget.preferCurrentLocation) {
          cameraPoints.add(currentLatLng);
        }

        final poi = await controller.labelLayer.addPoi(
          currentLatLng,
          style: kakao.PoiStyle(),
          text: '내 위치',
        );

        if (!mounted || token != _renderToken) {
          return;
        }
        _pois.add(poi);
      }

      for (final place in renderPlaces) {
        final position = kakao.LatLng(
          place.coordinate.latitude,
          place.coordinate.longitude,
        );
        cameraPoints.add(position);

        final poi = await controller.labelLayer.addPoi(
          position,
          style: kakao.PoiStyle(
            icon: kakao.KImage.fromAsset(
              MapPoiMarkerAsset.fromCategory(place.category),
              MapPoiMarkerAsset.iconWidth,
              MapPoiMarkerAsset.iconHeight,
            ),
          ),
          text: place.name,
          onClick: widget.onPlaceTap == null
              ? null
              : () => widget.onPlaceTap!(place),
        );

        if (!mounted || token != _renderToken) {
          return;
        }
        _pois.add(poi);
      }

      debugPrint(
        'KakaoMapBackground rendered ${_pois.length} poi(s) and '
        '${widget.routePath.length > 1 ? 1 : 0} route(s).',
      );

      if (widget.routePath.length > 1) {
        final routePoints = widget.routePath
            .map((point) => kakao.LatLng(point.latitude, point.longitude))
            .toList(growable: false);
        cameraPoints.addAll(routePoints);

        _route = await controller.routeLayer.addRoute(
          routePoints,
          kakao.RouteStyle(Colors.black, 8),
        );
      }

      if (!mounted || token != _renderToken) {
        return;
      }

      if (cameraPoints.isEmpty) {
        await controller.moveCamera(
          kakao.CameraUpdate.newCenterPosition(
            kakao.LatLng(
              gomsFallbackSchoolCoordinate.latitude,
              gomsFallbackSchoolCoordinate.longitude,
            ),
            zoomLevel: 16,
          ),
        );
      } else {
        await controller.moveCamera(
          kakao.CameraUpdate.fitMapPoints(
            cameraPoints,
            padding: widget.showRoutePreview ? 120 : 96,
            zoomLevel: 16,
          ),
        );
      }

      _clearError();
    } catch (e) {
      _setError(_buildErrorMessage(e));
    }
  }

  List<PopularPlace> _buildRenderPlaces() {
    final unique = <String, PopularPlace>{};
    for (final place in widget.places) {
      unique['${place.name}-${place.address}'] = place;
    }

    final focusPlace = widget.focusPlace;
    if (focusPlace != null) {
      unique['${focusPlace.name}-${focusPlace.address}'] = focusPlace;
    }

    return unique.values.toList(growable: false);
  }

  Future<void> _clearOverlays(kakao.KakaoMapController controller) async {
    if (_route != null) {
      try {
        await controller.routeLayer.removeRoute(_route!);
      } catch (_) {}
      _route = null;
    }

    for (final poi in _pois) {
      try {
        await controller.labelLayer.removePoi(poi);
      } catch (_) {}
    }
    _pois.clear();
  }

  void _setError(String message) {
    ref.read(kakaoMapBackgroundErrorProvider(_mapId).notifier).setMessage(
          message,
        );
  }

  void _clearError() {
    if (ref.read(kakaoMapBackgroundErrorProvider(_mapId)) == null) {
      return;
    }
    ref.read(kakaoMapBackgroundErrorProvider(_mapId).notifier).setMessage(null);
  }

  String _buildErrorMessage(Object error) {
    final raw = error.toString();
    if (raw.contains('KakaoAuthError') ||
        raw.contains('401') ||
        raw.contains('403')) {
      return '카카오 지도 인증에 실패했습니다. Android 키 해시 등록 상태를 확인해주세요.';
    }

    return '지도를 불러오지 못했습니다.';
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = ref.watch(kakaoMapBackgroundErrorProvider(_mapId));
    final controller = ref.watch(kakaoMapBackgroundControllerProvider(_mapId));
    final unavailableReason = KakaoMapRuntime.instance.unavailableReason;
    if (!KakaoMapRuntime.instance.isMapAvailable) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            unavailableReason ?? '지도를 불러오지 못했습니다.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final initialCoordinate =
        widget.preferCurrentLocation && widget.currentLocation != null
            ? widget.currentLocation!
            : widget.focusPlace?.coordinate ??
                (widget.places.isNotEmpty
                    ? widget.places.first.coordinate
                    : gomsFallbackSchoolCoordinate);

    return Stack(
      children: [
        Positioned.fill(
          child: kakao.KakaoMap(
            option: kakao.KakaoMapOption(
              position: kakao.LatLng(
                initialCoordinate.latitude,
                initialCoordinate.longitude,
              ),
              zoomLevel: 16,
            ),
            onMapReady: (controller) {
              if (!mounted) {
                return;
              }
              _controller = controller;
              ref
                  .read(kakaoMapBackgroundControllerProvider(_mapId).notifier)
                  .setController(controller);
              debugPrint('KakaoMapBackground onMapReady');
              _renderMapObjects();
            },
            onMapError: (error) {
              debugPrint('KakaoMapBackground onMapError: $error');
              _setError(_buildErrorMessage(error));
            },
          ),
        ),
        if (controller == null && errorMessage == null)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (errorMessage != null)
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
