import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';

class KakaoPlaceSearchResult {
  final String id;
  final String name;
  final String category;
  final String address;
  final int? distanceMeters;
  final MapCoordinate coordinate;

  const KakaoPlaceSearchResult({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.coordinate,
    this.distanceMeters,
  });
}

class KakaoLocalService {
  KakaoLocalService({HttpClient? httpClient})
      : _httpClient = httpClient ?? HttpClient();

  final HttpClient _httpClient;

  String get _restApiKey {
    final key = dotenv.env['KAKAO_REST_API_KEY']?.trim() ?? '';
    if (key.isEmpty) {
      throw const KakaoApiException('카카오 REST API 키가 설정되지 않았습니다.');
    }
    return key;
  }

  Future<MapCoordinate> resolveAddress(String address) async {
    final uri = Uri.https(
      'dapi.kakao.com',
      '/v2/local/search/address.json',
      {'query': address},
    );

    final response = await _getJson(uri);
    final documents = (response['documents'] as List<dynamic>? ?? const []);

    if (documents.isEmpty) {
      throw KakaoApiException('주소 좌표를 찾을 수 없습니다: $address');
    }

    final first = documents.first as Map<String, dynamic>;
    return MapCoordinate(
      latitude: double.parse(first['y'] as String),
      longitude: double.parse(first['x'] as String),
    );
  }

  Future<List<KakaoPlaceSearchResult>> searchNearbyByKeyword({
    required String query,
    required MapCoordinate center,
    int radius = 1500,
    int size = 5,
  }) async {
    final uri = Uri.https(
      'dapi.kakao.com',
      '/v2/local/search/keyword.json',
      {
        'query': query,
        'x': center.longitude.toString(),
        'y': center.latitude.toString(),
        'radius': radius.toString(),
        'sort': 'distance',
        'size': size.toString(),
      },
    );

    final response = await _getJson(uri);
    final documents = (response['documents'] as List<dynamic>? ?? const []);

    return documents
        .whereType<Map<String, dynamic>>()
        .map(
          (document) => KakaoPlaceSearchResult(
            id: document['id'] as String,
            name: document['place_name'] as String? ?? '',
            category: _categoryFromRaw(document['category_name'] as String?),
            address:
                (document['road_address_name'] as String?)?.trim().isNotEmpty ==
                        true
                    ? document['road_address_name'] as String
                    : document['address_name'] as String? ?? '',
            distanceMeters: int.tryParse(document['distance'] as String? ?? ''),
            coordinate: MapCoordinate(
              latitude: double.parse(document['y'] as String),
              longitude: double.parse(document['x'] as String),
            ),
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final request = await _httpClient.getUrl(uri);
    request.headers
        .set(HttpHeaders.authorizationHeader, 'KakaoAK $_restApiKey');
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KakaoApiException(
        '카카오 로컬 API 호출에 실패했습니다. (${response.statusCode})',
      );
    }

    return jsonDecode(body) as Map<String, dynamic>;
  }

  String _categoryFromRaw(String? rawCategory) {
    if (rawCategory == null || rawCategory.trim().isEmpty) {
      return '장소';
    }

    final parts = rawCategory.split('>').map((part) => part.trim()).toList();
    return parts.isEmpty ? rawCategory : parts.last;
  }
}

class KakaoApiException implements Exception {
  final String message;

  const KakaoApiException(this.message);

  @override
  String toString() => message;
}
