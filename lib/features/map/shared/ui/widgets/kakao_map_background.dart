import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goms/features/map/data/kakao_map_runtime.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/shared/ui/models/map_poi_marker_asset.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

class KakaoMapBackground extends StatefulWidget {
  final List<PopularPlace> places;
  final PopularPlace? focusPlace;
  final List<MapCoordinate> routePath;
  final bool showRoutePreview;
  final bool preserveZoomLevelOnSinglePlaceSelection;
  final MapCoordinate? currentLocation;
  final bool preferCurrentLocation;
  final bool showCurrentLocationLabel;
  final ValueChanged<kakao.KakaoMapController>? onControllerReady;
  final ValueChanged<PopularPlace>? onPlaceTap;
  final ValueChanged<MapCoordinate>? onMapTap;

  const KakaoMapBackground({
    super.key,
    this.places = const <PopularPlace>[],
    this.focusPlace,
    this.routePath = const <MapCoordinate>[],
    this.showRoutePreview = false,
    this.preserveZoomLevelOnSinglePlaceSelection = false,
    this.currentLocation,
    this.preferCurrentLocation = false,
    this.showCurrentLocationLabel = true,
    this.onControllerReady,
    this.onPlaceTap,
    this.onMapTap,
  });

  @override
  State<KakaoMapBackground> createState() => _KakaoMapBackgroundState();
}

class _KakaoMapBackgroundState extends State<KakaoMapBackground> {
  static const _mapLoadTimeout = Duration(seconds: 10);
  static const _defaultZoomLevel = 16;
  static const _selectedPlaceZoomLevel = 18;
  static const _instantCameraAnimation = kakao.CameraAnimation(0);

  kakao.KakaoMapController? _controller;
  final List<kakao.Poi> _pois = <kakao.Poi>[];
  kakao.Route? _route;
  int _renderToken = 0;
  String? _lastCameraSignature;
  String? _errorMessage;
  Timer? _loadingTimeout;

  @override
  void initState() {
    super.initState();
    _armLoadingTimeout();
  }

  @override
  void didUpdateWidget(covariant KakaoMapBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    _armLoadingTimeout();
    if (KakaoMapRuntime.instance.isMapAvailable) {
      _renderMapObjects();
    }
  }

  @override
  void dispose() {
    _loadingTimeout?.cancel();
    super.dispose();
  }

  void _armLoadingTimeout() {
    _loadingTimeout?.cancel();
    if (!KakaoMapRuntime.instance.isMapAvailable ||
        _controller != null ||
        _errorMessage != null) {
      return;
    }

    _loadingTimeout = Timer(_mapLoadTimeout, () {
      if (!mounted || _controller != null || _errorMessage != null) {
        return;
      }

      setState(() {
        _errorMessage = '지도를 불러오지 못했습니다. 카카오 지도 초기화 또는 플랫폼 환경을 확인해주세요.';
      });
    });
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

      final shouldIncludeCurrentLocationInCamera =
          widget.preferCurrentLocation &&
              !widget.showRoutePreview &&
              renderPlaces.isEmpty;

      if (currentLocation != null) {
        final currentLatLng = kakao.LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        );
        if (shouldIncludeCurrentLocationInCamera) {
          cameraPoints.add(currentLatLng);
        }

        final poi = await controller.labelLayer.addPoi(
          currentLatLng,
          style: kakao.PoiStyle(),
          text: widget.showCurrentLocationLabel ? '내 위치' : '',
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

      final cameraSignature = _buildCameraSignature(
        renderPlaces: renderPlaces,
        cameraPoints: cameraPoints,
      );
      if (cameraSignature != _lastCameraSignature) {
        await _moveCamera(
          controller: controller,
          renderPlaces: renderPlaces,
          cameraPoints: cameraPoints,
        );
        _lastCameraSignature = cameraSignature;
      }

      _clearError();
    } catch (e) {
      _setError(_buildErrorMessage(e));
    }
  }

  Future<void> _moveCamera({
    required kakao.KakaoMapController controller,
    required List<PopularPlace> renderPlaces,
    required List<kakao.LatLng> cameraPoints,
  }) async {
    if (cameraPoints.isEmpty) {
      await controller.moveCamera(
        kakao.CameraUpdate.newCenterPosition(
          kakao.LatLng(
            gomsFallbackSchoolCoordinate.latitude,
            gomsFallbackSchoolCoordinate.longitude,
          ),
          zoomLevel: _defaultZoomLevel,
        ),
      );
      return;
    }

    if (!widget.showRoutePreview && renderPlaces.length == 1) {
      final place = renderPlaces.first;
      final zoomLevel = widget.preserveZoomLevelOnSinglePlaceSelection
          ? (await controller.getCameraPosition()).zoomLevel
          : _selectedPlaceZoomLevel;
      await controller.moveCamera(
        kakao.CameraUpdate.newCenterPosition(
          kakao.LatLng(
            place.coordinate.latitude,
            place.coordinate.longitude,
          ),
          zoomLevel: zoomLevel,
        ),
        animation: _instantCameraAnimation,
      );
      return;
    }

    await controller.moveCamera(
      kakao.CameraUpdate.fitMapPoints(
        cameraPoints,
        padding: widget.showRoutePreview ? 120 : 96,
        zoomLevel: _defaultZoomLevel,
      ),
    );
  }

  String _buildCameraSignature({
    required List<PopularPlace> renderPlaces,
    required List<kakao.LatLng> cameraPoints,
  }) {
    final placeSignature = renderPlaces
        .map(
          (place) =>
              '${place.placeId ?? place.name}:${place.coordinate.latitude.toStringAsFixed(6)},${place.coordinate.longitude.toStringAsFixed(6)}',
        )
        .join('|');
    final pointSignature = cameraPoints
        .map(
          (point) =>
              '${point.latitude.toStringAsFixed(6)},${point.longitude.toStringAsFixed(6)}',
        )
        .join('|');
    return '$placeSignature::$pointSignature::'
        '${widget.showRoutePreview ? 'route' : 'place'}';
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
    _loadingTimeout?.cancel();
    if (!mounted) {
      return;
    }
    setState(() {
      _errorMessage = message;
    });
  }

  void _clearError() {
    if (_errorMessage == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _errorMessage = null;
    });
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
              _loadingTimeout?.cancel();
              setState(() {
                _controller = controller;
                _errorMessage = null;
              });
              widget.onControllerReady?.call(controller);
              debugPrint('KakaoMapBackground onMapReady');
              _renderMapObjects();
            },
            onMapClick: (point, position) {
              widget.onMapTap?.call(MapCoordinate.fromKakaoLatLng(position));
            },
            onMapError: (error) {
              debugPrint('KakaoMapBackground onMapError: $error');
              _setError(_buildErrorMessage(error));
            },
          ),
        ),
        if (_controller == null && _errorMessage == null)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (_errorMessage != null)
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _errorMessage!,
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
