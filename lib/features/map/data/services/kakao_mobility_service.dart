import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/presentation/pages/direction/models/direction_state.dart';

class KakaoMobilityService {
  KakaoMobilityService({HttpClient? httpClient})
      : _httpClient = httpClient ?? HttpClient();

  final HttpClient _httpClient;

  String get _restApiKey {
    final key = dotenv.env['KAKAO_REST_API_KEY']?.trim() ?? '';
    if (key.isEmpty) {
      throw const KakaoMobilityException('카카오 REST API 키가 설정되지 않았습니다.');
    }
    return key;
  }

  Future<List<RouteOption>> fetchRoutes({
    required MapCoordinate origin,
    required MapCoordinate destination,
    required String originName,
    required String destinationName,
  }) async {
    final uri = Uri.https(
      'apis-navi.kakaomobility.com',
      '/v1/directions',
      {
        'origin':
            '${origin.longitude},${origin.latitude},name=${Uri.encodeComponent(originName)}',
        'destination':
            '${destination.longitude},${destination.latitude},name=${Uri.encodeComponent(destinationName)}',
        'priority': 'RECOMMEND',
        'alternatives': 'true',
        'summary': 'false',
        'road_details': 'false',
      },
    );

    final response = await _getJson(uri);
    final routes = (response['routes'] as List<dynamic>? ?? const []);

    if (routes.isEmpty) {
      throw const KakaoMobilityException('경로를 찾을 수 없습니다.');
    }

    return routes
        .whereType<Map<String, dynamic>>()
        .map(_toRouteOption)
        .where((route) => route.path.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final request = await _httpClient.getUrl(uri);
    request.headers.set(HttpHeaders.authorizationHeader, 'KakaoAK $_restApiKey');
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KakaoMobilityException(
        '카카오모빌리티 API 호출에 실패했습니다. (${response.statusCode})',
      );
    }

    return jsonDecode(body) as Map<String, dynamic>;
  }

  RouteOption _toRouteOption(Map<String, dynamic> route) {
    final summary = route['summary'] as Map<String, dynamic>? ?? const {};
    final sections = (route['sections'] as List<dynamic>? ?? const []);
    final fare = summary['fare'] as Map<String, dynamic>? ?? const {};

    return RouteOption(
      label: _priorityLabel(summary['priority'] as String?),
      minutes: (((summary['duration'] as num?)?.toInt() ?? 0) / 60).ceil(),
      meters: (summary['distance'] as num?)?.toInt() ?? 0,
      taxiFare: (fare['taxi'] as num?)?.toInt() ?? 0,
      tollFare: (fare['toll'] as num?)?.toInt() ?? 0,
      path: _extractPath(sections),
      steps: _extractGuides(sections),
    );
  }

  List<MapCoordinate> _extractPath(List<dynamic> sections) {
    final path = <MapCoordinate>[];

    for (final section in sections.whereType<Map<String, dynamic>>()) {
      final roads = (section['roads'] as List<dynamic>? ?? const []);

      for (final road in roads.whereType<Map<String, dynamic>>()) {
        final vertexes = (road['vertexes'] as List<dynamic>? ?? const []);
        for (var index = 0; index + 1 < vertexes.length; index += 2) {
          final longitude = (vertexes[index] as num).toDouble();
          final latitude = (vertexes[index + 1] as num).toDouble();

          final point = MapCoordinate(
            latitude: latitude,
            longitude: longitude,
          );

          final isDuplicate = path.isNotEmpty &&
              path.last.latitude == point.latitude &&
              path.last.longitude == point.longitude;
          if (!isDuplicate) {
            path.add(point);
          }
        }
      }
    }

    return path;
  }

  List<RouteStep> _extractGuides(List<dynamic> sections) {
    final guides = <RouteStep>[];

    for (final section in sections.whereType<Map<String, dynamic>>()) {
      final sectionGuides = (section['guides'] as List<dynamic>? ?? const []);
      for (final guide in sectionGuides.whereType<Map<String, dynamic>>()) {
        final guidance = (guide['guidance'] as String? ?? '').trim();
        final name = (guide['name'] as String? ?? '').trim();
        final title = guidance.isNotEmpty ? guidance : (name.isNotEmpty ? name : '이동');

        guides.add(
          RouteStep(
            title: title,
            description: _buildGuideDescription(guide),
            distanceMeters: (guide['distance'] as num?)?.toInt() ?? 0,
            durationSeconds: (guide['duration'] as num?)?.toInt() ?? 0,
            type: (guide['type'] as num?)?.toInt() ?? 0,
          ),
        );
      }
    }

    return guides;
  }

  String _buildGuideDescription(Map<String, dynamic> guide) {
    final distance = (guide['distance'] as num?)?.toInt() ?? 0;
    final durationSeconds = (guide['duration'] as num?)?.toInt() ?? 0;
    final durationMinutes = (durationSeconds / 60).ceil();

    if (distance == 0 && durationMinutes == 0) {
      return '바로 이동';
    }

    if (distance == 0) {
      return '$durationMinutes분 소요';
    }

    if (durationMinutes == 0) {
      return '${distance}m 이동';
    }

    return '${distance}m | $durationMinutes분';
  }

  String _priorityLabel(String? priority) {
    return switch (priority) {
      'TIME' => '최단 시간',
      'DISTANCE' => '최단 거리',
      _ => '추천',
    };
  }
}

class KakaoMobilityException implements Exception {
  final String message;

  const KakaoMobilityException(this.message);

  @override
  String toString() => message;
}

