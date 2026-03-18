import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/features/map/data/kakao_map_runtime.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/models/map_coordinate.dart';
import 'package:goms/features/map/presentation/pages/main/models/popular_place.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

class KakaoMapBackground extends StatefulWidget {
  final List<PopularPlace> places;
  final PopularPlace? focusPlace;
  final List<MapCoordinate> routePath;
  final bool showRoutePreview;

  const KakaoMapBackground({
    super.key,
    this.places = const <PopularPlace>[],
    this.focusPlace,
    this.routePath = const <MapCoordinate>[],
    this.showRoutePreview = false,
  });

  @override
  State<KakaoMapBackground> createState() => _KakaoMapBackgroundState();
}

class _KakaoMapBackgroundState extends State<KakaoMapBackground> {
  kakao.KakaoMapController? _controller;
  final List<kakao.Poi> _pois = <kakao.Poi>[];
  kakao.Route? _route;
  kakao.KImage? _defaultMarker;
  kakao.KImage? _focusedMarker;
  int _renderToken = 0;
  String? _errorMessage;

  @override
  void didUpdateWidget(covariant KakaoMapBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
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

      await _ensureMarkerImages();
      if (!mounted || token != _renderToken) {
        return;
      }

      final cameraPoints = <kakao.LatLng>[];
      final renderPlaces = _buildRenderPlaces();

      for (final place in renderPlaces) {
        final position = kakao.LatLng(
          place.coordinate.latitude,
          place.coordinate.longitude,
        );
        cameraPoints.add(position);

        final poi = await controller.labelLayer.addPoi(
          position,
          style: kakao.PoiStyle(
            icon: _isFocused(place) ? _focusedMarker : _defaultMarker,
          ),
          text: place.name,
        );

        if (!mounted || token != _renderToken) {
          return;
        }
        _pois.add(poi);
      }

      if (widget.routePath.length > 1) {
        final routePoints = widget.routePath
            .map((point) => kakao.LatLng(point.latitude, point.longitude))
            .toList(growable: false);
        cameraPoints.addAll(routePoints);

        _route = await controller.routeLayer.addRoute(
          routePoints,
          kakao.RouteStyle(
            AppColors.mainColor,
            8,
            strokeColor: Colors.white,
            strokeWidth: 2,
          ),
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

  bool _isFocused(PopularPlace place) {
    final focusPlace = widget.focusPlace;
    if (focusPlace == null) {
      return false;
    }

    return focusPlace.name == place.name && focusPlace.address == place.address;
  }

  Future<void> _ensureMarkerImages() async {
    _defaultMarker ??= await _buildMarkerImage(
      fillColor: const Color(0xFF4A4A4A),
      iconColor: Colors.white,
    );
    _focusedMarker ??= await _buildMarkerImage(
      fillColor: AppColors.mainColor,
      iconColor: Colors.white,
    );
  }

  Future<kakao.KImage> _buildMarkerImage({
    required Color fillColor,
    required Color iconColor,
  }) {
    return kakao.KImage.fromWidget(
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.location_on_rounded,
          color: iconColor,
          size: 20,
        ),
      ),
      const Size(34, 34),
      context: context,
    );
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
    if (!mounted) {
      _errorMessage = message;
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
      _errorMessage = null;
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
      return '카카오 지도 인증에 실패했습니다. Android는 키 해시 등록, iOS는 번들 ID 등록 상태를 확인해주세요.';
    }

    return '지도를 불러오지 못했습니다.';
  }

  @override
  Widget build(BuildContext context) {
    final unavailableReason = KakaoMapRuntime.instance.unavailableReason;
    if (!KakaoMapRuntime.instance.isMapAvailable) {
      return ColoredBox(
        color: AppColors.background,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              unavailableReason ?? '지도를 불러오지 못했습니다.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    final initialCoordinate =
        widget.focusPlace?.coordinate ??
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
              _controller = controller;
              _renderMapObjects();
            },
            onMapError: (error) {
              _setError(_buildErrorMessage(error));
            },
            forceHybridComposition: true,
          ),
        ),
        if (_controller == null && _errorMessage == null)
          const Positioned.fill(
            child: ColoredBox(
              color: AppColors.background,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ),
        if (_errorMessage != null)
          Positioned.fill(
            child: ColoredBox(
              color: AppColors.background,
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
          ),
      ],
    );
  }
}
