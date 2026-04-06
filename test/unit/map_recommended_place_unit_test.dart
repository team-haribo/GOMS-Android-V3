import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/data/datasources/recommended_place_remote_datasource.dart';
import 'package:goms/features/map/data/repositories/recommended_place_repository_impl.dart';
import 'package:goms/features/map/data/response/recommended_place_response.dart';
import 'package:goms/features/map/data/response/recommended_places_response.dart';
import 'package:goms/features/map/domain/usecases/get_recommended_places_usecase.dart';

void main() {
  group('RecommendedPlacesResponse', () {
    test('parses places payload into entity-ready models', () {
      final response = RecommendedPlacesResponse.fromJson({
        'places': [
          {
            'placeId': 1,
            'placeName': '테스트 카페',
            'category': '카페',
            'address': '광주광역시 테스트로 1',
            'latitude': 35.1,
            'longitude': 126.9,
            'reviewCount': 2,
            'recommendCount': 3,
            'recommended': true,
          },
        ],
      });

      expect(response.places, hasLength(1));
      expect(
        response.places.first,
        isA<RecommendedPlaceResponse>()
            .having((place) => place.placeId, 'placeId', 1)
            .having((place) => place.placeName, 'placeName', '테스트 카페')
            .having((place) => place.address, 'address', '광주광역시 테스트로 1')
            .having((place) => place.reviewCount, 'reviewCount', 2)
            .having((place) => place.recommendCount, 'recommendCount', 3)
            .having((place) => place.recommended, 'recommended', isTrue),
      );

      final entity = response.toEntity().single;
      expect(entity.placeId, 1);
      expect(entity.placeName, '테스트 카페');
      expect(entity.category, '카페');
      expect(entity.address, '광주광역시 테스트로 1');
      expect(entity.coordinate?.latitude, 35.1);
      expect(entity.coordinate?.longitude, 126.9);
      expect(entity.reviewCount, 2);
      expect(entity.recommendCount, 3);
      expect(entity.recommended, isTrue);
    });
  });

  group('RecommendedPlaceRepositoryImpl', () {
    test('maps datasource response to entities', () async {
      final repository = RecommendedPlaceRepositoryImpl(
        _FakeRecommendedPlaceRemoteDataSource(),
      );
      final useCase = GetRecommendedPlacesUseCase(repository);

      final entities = await useCase.call();

      expect(entities, hasLength(2));
      expect(entities.first.placeId, 10);
      expect(entities.first.placeName, '추천 카페');
      expect(entities.first.reviewCount, 4);
      expect(entities.first.recommendCount, 7);
      expect(entities.first.recommended, isTrue);
      expect(entities.last.placeId, 20);
    });
  });
}

class _FakeRecommendedPlaceRemoteDataSource
    extends RecommendedPlaceRemoteDataSource {
  _FakeRecommendedPlaceRemoteDataSource() : super(Dio());

  @override
  Future<RecommendedPlacesResponse> getRecommendedPlaces() async {
    return RecommendedPlacesResponse.fromJson({
      'places': [
        {
          'placeId': 10,
          'placeName': '추천 카페',
          'category': '카페',
          'address': '광주광역시 1',
          'reviewCount': 4,
          'recommendCount': 7,
          'recommended': true,
        },
        {
          'placeId': 20,
          'placeName': '추천 식당',
          'category': '한식',
          'address': '광주광역시 2',
          'reviewCount': 1,
          'recommendCount': 2,
          'recommended': false,
        },
      ],
    });
  }
}
