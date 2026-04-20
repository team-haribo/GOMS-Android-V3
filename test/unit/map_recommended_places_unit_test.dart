import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/ui/providers/map_screen_provider.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';

void main() {
  group('MapScreenNotifier', () {
    test('loads hot place markers first', () async {
      final repository = _TrackingRecommendedPlaceRepository();
      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      expect(repository.hotPlacesRequested, isTrue);
      expect(repository.allPlacesRequested, isFalse);
    });

    test('hydrates hot places from server fields only', () async {
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
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);
      final place =
          state.popularPlaces.firstWhere((place) => place.placeId == 5001);

      expect(state.status, MapScreenStatus.success);
      expect(state.popularPlaces, hasLength(1));
      expect(state.recommendedCount, 0);
      expect(state.reviewCount, 0);
      expect(place.placeId, 5001);
      expect(place.name, '테스트 카페');
      expect(place.category, '카페');
      expect(place.address, '광주광역시 테스트로 1');
      expect(place.coordinate.latitude, 35.124);
      expect(place.recommended, 5);
      expect(place.isRecommended, isTrue);
      expect(state.reviewModels, isEmpty);
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
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);
      final place =
          state.popularPlaces.firstWhere((place) => place.placeId == 999);

      expect(state.status, MapScreenStatus.success);
      expect(state.popularPlaces, hasLength(1));
      expect(place.placeId, 999);
      expect(place.name, '추천 장소 999');
      expect(place.address, gomsSchoolAddress);
      expect(place.coordinate, gomsFallbackSchoolCoordinate);
      expect(place.review, 1);
      expect(place.recommended, 2);
    });

    test('falls back to all places when hot place API fails', () async {
      final repository = _HotPlaceFailingRepository();
      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);

      expect(state.status, MapScreenStatus.success);
      expect(state.errorMessage, isNull);
      expect(state.popularPlaces, hasLength(1));
      expect(state.popularPlaces.first.name, '대체 장소');
      expect(repository.allPlacesRequested, isTrue);
      expect(state.recommendedCount, 0);
    });

    test('returns failure state when every place API fails', () async {
      final repository = _ThrowingRecommendedPlaceRepository();
      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
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
  Future<List<RecommendedPlaceEntity>> getPlaces() async => places;

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {}

  @override
  Future<RecommendedPlaceEntity> getPlaceDetail(int placeId) async =>
      places.first;

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async =>
      const [];

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async =>
      places;

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async => places;

  @override
  Future<int> getRecommendedPlacesCount() async => places.length;

  @override
  Future<bool> recommendPlace(int placeId) async => true;

  @override
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword) async =>
      places;

  @override
  Future<bool> unRecommendPlace(int placeId) async => false;

  @override
  Future<void> deleteReview(int reviewId) {
    // TODO: implement deleteReview
    throw UnimplementedError();
  }

  @override
  Future<int> getMyReviewCount() {
    // TODO: implement getMyReviewCount
    throw UnimplementedError();
  }

  @override
  Future<List<MyReviewEntity>> getMyReviews() {
    // TODO: implement getMyReviews
    throw UnimplementedError();
  }
}

class _TrackingRecommendedPlaceRepository
    extends _FakeRecommendedPlaceRepository {
  _TrackingRecommendedPlaceRepository() : super(const []);

  bool hotPlacesRequested = false;
  bool allPlacesRequested = false;

  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async {
    allPlacesRequested = true;
    return super.getPlaces();
  }

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async {
    hotPlacesRequested = true;
    return const [];
  }
}

class _ThrowingRecommendedPlaceRepository
    implements RecommendedPlaceRepository {
  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/v3/place'),
    );
  }

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {}

  @override
  Future<RecommendedPlaceEntity> getPlaceDetail(int placeId) async {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/v3/place/$placeId'),
    );
  }

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async =>
      const [];

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/v3/place/hot-place'),
    );
  }

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async => const [];

  @override
  Future<int> getRecommendedPlacesCount() async => 0;

  @override
  Future<bool> recommendPlace(int placeId) async => true;

  @override
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword) async =>
      const [];

  @override
  Future<bool> unRecommendPlace(int placeId) async => false;

  @override
  Future<void> deleteReview(int reviewId) {
    // TODO: implement deleteReview
    throw UnimplementedError();
  }

  @override
  Future<int> getMyReviewCount() {
    // TODO: implement getMyReviewCount
    throw UnimplementedError();
  }

  @override
  Future<List<MyReviewEntity>> getMyReviews() {
    // TODO: implement getMyReviews
    throw UnimplementedError();
  }
}

class _HotPlaceFailingRepository extends _FakeRecommendedPlaceRepository {
  _HotPlaceFailingRepository()
      : super(const [
          RecommendedPlaceEntity(
            placeId: 77,
            placeName: '대체 장소',
            category: '카페',
            address: '광주광역시 테스트로 77',
            coordinate: MapCoordinate(latitude: 35.12, longitude: 126.88),
            reviewCount: 3,
            recommendCount: 4,
            recommended: false,
          ),
        ]);

  bool allPlacesRequested = false;

  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async {
    allPlacesRequested = true;
    return super.getPlaces();
  }

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/v3/place/hot-place'),
    );
  }
}
