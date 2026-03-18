import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

/// 최소 구현용 카카오 지도 화면입니다.
///
/// 필수 설정:
/// - AndroidManifest.xml: INTERNET, ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION 권한 추가
/// - Info.plist: NSLocationWhenInUseUsageDescription 추가
/// - 카카오 개발자 콘솔에 Android 키 해시 / iOS 번들 ID 등록
/// - `kakao_map_sdk`는 Android x86/x64 에뮬레이터에서 동작하지 않을 수 있음
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  /// 앱 시작 시 한 번만 호출하면 됩니다.
  static Future<void> initializeKakaoSdk() async {
    if (_kakaoSdkInitialized) {
      return;
    }

    final nativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY']?.trim() ?? '';
    if (nativeAppKey.isEmpty) {
      throw const _KakaoConfigException('카카오 네이티브 앱 키가 설정되지 않았습니다.');
    }

    await kakao.KakaoMapSdk.instance.initialize(nativeAppKey);
    _kakaoSdkInitialized = true;
  }

  @override
  State<MapScreen> createState() => _MapScreenState();
}

bool _kakaoSdkInitialized = false;

String get _kakaoRestApiKey {
  final key = dotenv.env['KAKAO_REST_API_KEY']?.trim() ?? '';
  if (key.isEmpty) {
    throw const _KakaoConfigException('카카오 REST API 키가 설정되지 않았습니다.');
  }
  return key;
}

class _MapScreenState extends State<MapScreen> {
  static const kakao.LatLng _seoulCityHall = kakao.LatLng(37.5665, 126.9780);
  static const kakao.LatLng _gangnamStation = kakao.LatLng(37.4979, 127.0276);

  kakao.KakaoMapController? _mapController;
  kakao.Route? _routeOverlay;
  kakao.LatLng _origin = _seoulCityHall;

  bool _isSdkReady = false;
  bool _isFetchingRoute = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    final controller = _mapController;
    if (controller != null) {
      _removeRoute(controller);
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      await MapScreen.initializeKakaoSdk();
      _origin = await _getCurrentLocation() ?? _seoulCityHall;

      if (!mounted) {
        return;
      }

      setState(() {
        _isSdkReady = true;
      });
    } catch (error) {
      debugPrint('Kakao map initialize error: $error');
    }
  }

  Future<void> _onMapReady(kakao.KakaoMapController controller) async {
    _mapController = controller;
    await controller.moveCamera(
      kakao.CameraUpdate.newCenterPosition(_origin, zoomLevel: 16),
    );
  }

  Future<void> _startDirection() async {
    final controller = _mapController;
    if (controller == null || _isFetchingRoute) {
      return;
    }

    setState(() {
      _isFetchingRoute = true;
    });

    try {
      _origin = await _getCurrentLocation() ?? _origin;

      final polylinePoints = await _fetchRoutePolyline(
        origin: _origin,
        destination: _gangnamStation,
      );

      await _removeRoute(controller);

      // 길찾기 응답 좌표를 지도 위 선형 경로로 표시합니다.
      _routeOverlay = await controller.routeLayer.addRoute(
        polylinePoints,
        kakao.RouteStyle(
          const Color(0xFF1B6EF3),
          10,
          strokeColor: Colors.white,
          strokeWidth: 3,
        ),
      );

      await controller.moveCamera(
        kakao.CameraUpdate.fitMapPoints(
          <kakao.LatLng>[
            _origin,
            _gangnamStation,
            ...polylinePoints,
          ],
          padding: 96,
          zoomLevel: 15,
        ),
      );
    } catch (error) {
      debugPrint('Kakao route error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingRoute = false;
        });
      } else {
        _isFetchingRoute = false;
      }
    }
  }

  Future<List<kakao.LatLng>> _fetchRoutePolyline({
    required kakao.LatLng origin,
    required kakao.LatLng destination,
  }) async {
    final uri = Uri.https(
      'apis-navi.kakaomobility.com',
      '/v1/directions',
      <String, String>{
        'origin':
            '${origin.longitude},${origin.latitude},name=${Uri.encodeComponent('현재 위치')}',
        'destination':
            '${destination.longitude},${destination.latitude},name=${Uri.encodeComponent('강남역')}',
        'priority': 'RECOMMEND',
        'alternatives': 'false',
        'summary': 'false',
        'road_details': 'false',
      },
    );

    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'KakaoAK $_kakaoRestApiKey',
      );
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Kakao directions request failed (${response.statusCode})',
          uri: uri,
        );
      }

      final json = jsonDecode(body) as Map<String, dynamic>;
      final routes = (json['routes'] as List<dynamic>? ?? const <dynamic>[]);
      if (routes.isEmpty) {
        throw const FormatException('Empty route response');
      }

      final firstRoute = routes.first as Map<String, dynamic>;
      final sections =
          firstRoute['sections'] as List<dynamic>? ?? const <dynamic>[];
      final polylinePoints = <kakao.LatLng>[];

      for (final section in sections.whereType<Map<String, dynamic>>()) {
        final roads = section['roads'] as List<dynamic>? ?? const <dynamic>[];

        for (final road in roads.whereType<Map<String, dynamic>>()) {
          final vertexes =
              road['vertexes'] as List<dynamic>? ?? const <dynamic>[];

          for (var index = 0; index + 1 < vertexes.length; index += 2) {
            final longitude = (vertexes[index] as num).toDouble();
            final latitude = (vertexes[index + 1] as num).toDouble();
            final point = kakao.LatLng(latitude, longitude);

            final isDuplicate = polylinePoints.isNotEmpty &&
                polylinePoints.last.latitude == point.latitude &&
                polylinePoints.last.longitude == point.longitude;

            if (!isDuplicate) {
              polylinePoints.add(point);
            }
          }
        }
      }

      if (polylinePoints.length < 2) {
        throw const FormatException('Not enough polyline points');
      }

      return polylinePoints;
    } finally {
      client.close(force: true);
    }
  }

  Future<kakao.LatLng?> _getCurrentLocation() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return kakao.LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  Future<void> _removeRoute(kakao.KakaoMapController controller) async {
    if (_routeOverlay == null) {
      return;
    }

    try {
      await controller.routeLayer.removeRoute(_routeOverlay!);
    } catch (_) {
      // 이미 제거된 경로일 수 있으므로 무시합니다.
    } finally {
      _routeOverlay = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSdkReady) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: kakao.KakaoMap(
              option: const kakao.KakaoMapOption(
                position: _seoulCityHall,
                zoomLevel: 16,
              ),
              onMapReady: _onMapReady,
              onMapError: (error) {
                debugPrint('Kakao map error: $error');
              },
              forceHybridComposition: true,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isFetchingRoute ? null : _startDirection,
                child: _isFetchingRoute
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('길찾기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KakaoConfigException implements Exception {
  final String message;

  const _KakaoConfigException(this.message);

  @override
  String toString() => message;
}
