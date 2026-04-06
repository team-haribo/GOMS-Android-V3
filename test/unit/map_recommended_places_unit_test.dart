import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/presentation/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/presentation/providers/map_screen_provider.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';
import 'package:goms/features/map/domain/usecases/get_recommended_places_usecase.dart';

void main() {
  group('MapScreenNotifier', () {
    test('hydrates popular places from server fields only', () async {
      const repository = _FakeRecommendedPlaceRepository([
        RecommendedPlaceEntity(
          placeId: 5001,
          placeName: '테스트 카페',
          category: '카페',
          address: '광주광역시 테스트로 1',
          coordinate: MapCoordinate(latitude: 35.124, longitude: 126.901),
          reviewCount: 2,
          recommendCount: 5,
          recommended: true,
        ),
      ]);
      final container = ProviderContainer(
        overrides: [
          getRecommendedPlacesUseCaseProvider.overrideWithValue(
            const GetRecommendedPlacesUseCase(repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);
      final place =
          state.popularPlaces.firstWhere((place) => place.placeId == 5001);

      expect(state.status, MapScreenStatus.success);
      expect(state.popularPlaces, hasLength(3));
      expect(state.recommendedCount, 3);
      expect(state.reviewCount, 9);
      expect(place.placeId, 5001);
      expect(place.name, '테스트 카페');
      expect(place.category, '카페');
      expect(place.address, '광주광역시 테스트로 1');
      expect(place.coordinate.latitude, 35.124);
      expect(place.recommended, 5);
      expect(state.reviewModels, hasLength(2));
    });

    test('falls back to placeholder values when server fields are missing',
        () async {
      const repository = _FakeRecommendedPlaceRepository([
        RecommendedPlaceEntity(
          placeId: 999,
          reviewCount: 1,
          recommendCount: 2,
          recommended: true,
        ),
      ]);
      final container = ProviderContainer(
        overrides: [
          getRecommendedPlacesUseCaseProvider.overrideWithValue(
            const GetRecommendedPlacesUseCase(repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);
      final place =
          state.popularPlaces.firstWhere((place) => place.placeId == 999);

      expect(state.status, MapScreenStatus.success);
      expect(state.popularPlaces, hasLength(3));
      expect(place.placeId, 999);
      expect(place.name, '추천 장소 999');
      expect(place.address, gomsSchoolAddress);
      expect(place.coordinate, gomsFallbackSchoolCoordinate);
      expect(place.review, 1);
      expect(place.recommended, 2);
    });

    test('returns failure state when recommended API fails', () async {
      final repository = _ThrowingRecommendedPlaceRepository();
      final container = ProviderContainer(
        overrides: [
          getRecommendedPlacesUseCaseProvider.overrideWithValue(
            GetRecommendedPlacesUseCase(repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);

      expect(state.status, MapScreenStatus.failure);
      expect(state.errorMessage, '장소 정보를 불러오는데 실패했습니다.');
      expect(state.recommendedCount, 0);
      expect(state.popularPlaces, isEmpty);
    });
  });
}

class _FakeRecommendedPlaceRepository implements RecommendedPlaceRepository {
  const _FakeRecommendedPlaceRepository(this.places);

  final List<RecommendedPlaceEntity> places;

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async => places;
}

class _ThrowingRecommendedPlaceRepository
    implements RecommendedPlaceRepository {
  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/v3/place/recommended'),
    );
  }
}
