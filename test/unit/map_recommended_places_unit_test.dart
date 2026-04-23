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
import 'package:goms/features/map/review/ui/providers/write_review_provider.dart';

void main() {
  group('MapScreenNotifier', () {
    test('requests hot place markers before falling back', () async {
      final repository = _TrackingRecommendedPlaceRepository();
      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      expect(repository.hotPlacesRequested, isTrue);
      expect(repository.allPlacesRequested, isTrue);
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

    test('falls back to all places when hot place API returns empty', () async {
      final repository = _EmptyHotPlaceRepository();
      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);

      expect(state.status, MapScreenStatus.success);
      expect(state.popularPlaces, hasLength(1));
      expect(state.popularPlaces.first.name, '대체 인기 장소');
      expect(repository.allPlacesRequested, isTrue);
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

    test('deletes my review and updates local activity state', () async {
      final repository = _ReviewDeletingRepository(
        reviews: [
          const MyReviewEntity(
            reviewId: 11,
            placeId: 101,
            placeName: '학생식당',
            categoryName: '한식',
            address: '광주광역시 테스트로 11',
            content: '리뷰 1',
            reviewedAt: null,
          ),
          const MyReviewEntity(
            reviewId: 12,
            placeId: 102,
            placeName: '도서관 카페',
            categoryName: '카페',
            address: '광주광역시 테스트로 12',
            content: '리뷰 2',
            reviewedAt: null,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();
      await repository.deleteReview(11);
      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);
      expect(repository.deletedReviewIds, [11]);
      expect(state.reviewCount, 1);
      expect(state.reviewModels, hasLength(1));
      expect(state.reviewModels.single.reviewId, 12);
    });

    test('restores my review state when delete API fails', () async {
      final repository = _ReviewDeletingRepository(
        shouldThrowOnDelete: true,
        reviews: [
          const MyReviewEntity(
            reviewId: 21,
            placeId: 201,
            placeName: '기숙사 앞 카페',
            categoryName: '카페',
            address: '광주광역시 테스트로 21',
            content: '리뷰 A',
            reviewedAt: null,
          ),
          const MyReviewEntity(
            reviewId: 22,
            placeId: 202,
            placeName: '분식집',
            categoryName: '분식',
            address: '광주광역시 테스트로 22',
            content: '리뷰 B',
            reviewedAt: null,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      await expectLater(
        repository.deleteReview(21),
        throwsA(isA<DioException>()),
      );

      final state = container.read(mapScreenProvider);
      expect(repository.deletedReviewIds, isEmpty);
      expect(state.reviewCount, 2);
      expect(state.reviewModels, hasLength(2));
      expect(state.reviewModels.first.reviewId, 21);
    });

    test('refreshes my review ids after creating a review', () async {
      final repository = _ReviewCreatingRepository();
      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      expect(await container.read(myReviewIdsProvider.future), {1});

      final notifier = container.read(writeReviewProvider.notifier);
      notifier.onTextChanged('새 후기');

      await notifier.submitReview(
        placeId: 100,
        placeName: '학생식당',
        category: '한식',
        address: '광주광역시 테스트로 100',
        review: 1,
        recommended: 1,
      );

      expect(repository.createdPlaceId, 100);
      expect(repository.createdContent, '새 후기');
      expect(await container.read(myReviewIdsProvider.future), {1, 2});
    });

    test('keeps written reviews visible when count endpoint under-reports',
        () async {
      final repository = _ReviewCountMismatchRepository();
      final container = ProviderContainer(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(mapScreenProvider.notifier).fetchData();

      final state = container.read(mapScreenProvider);

      expect(state.reviewCount, 1);
      expect(state.reviewModels, hasLength(1));
      expect(state.reviewModels.single.placeName, '학생식당');
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
  Future<void> deleteReview(int reviewId) async {}

  @override
  Future<int> getMyReviewCount() async => 0;

  @override
  Future<List<MyReviewEntity>> getMyReviews() async => const [];
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
  Future<void> deleteReview(int reviewId) async {}

  @override
  Future<int> getMyReviewCount() async => 0;

  @override
  Future<List<MyReviewEntity>> getMyReviews() async => const [];
}

class _ReviewDeletingRepository extends _FakeRecommendedPlaceRepository {
  _ReviewDeletingRepository({
    required List<MyReviewEntity> reviews,
    this.shouldThrowOnDelete = false,
  })  : _reviews = List<MyReviewEntity>.of(reviews),
        super(const []);

  final List<MyReviewEntity> _reviews;
  final bool shouldThrowOnDelete;
  final List<int> deletedReviewIds = <int>[];

  @override
  Future<List<MyReviewEntity>> getMyReviews() async =>
      List<MyReviewEntity>.of(_reviews);

  @override
  Future<int> getMyReviewCount() async => _reviews.length;

  @override
  Future<void> deleteReview(int reviewId) async {
    if (shouldThrowOnDelete) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/v3/review/$reviewId'),
      );
    }

    deletedReviewIds.add(reviewId);
    _reviews.removeWhere((review) => review.reviewId == reviewId);
  }
}

class _ReviewCreatingRepository extends _FakeRecommendedPlaceRepository {
  _ReviewCreatingRepository()
      : _myReviews = <MyReviewEntity>[
          const MyReviewEntity(
            reviewId: 1,
            placeId: 10,
            placeName: '기존 장소',
            categoryName: '카페',
            address: '광주광역시 테스트로 10',
            content: '기존 후기',
            reviewedAt: null,
          ),
        ],
        super(const [
          RecommendedPlaceEntity(
            placeId: 100,
            placeName: '학생식당',
            category: '한식',
            address: '광주광역시 테스트로 100',
            coordinate: MapCoordinate(latitude: 35.124, longitude: 126.901),
            reviewCount: 1,
            recommendCount: 1,
            recommended: false,
          ),
        ]);

  final List<MyReviewEntity> _myReviews;
  int? createdPlaceId;
  String? createdContent;

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {
    createdPlaceId = placeId;
    createdContent = content;
    _myReviews.add(
      MyReviewEntity(
        reviewId: 2,
        placeId: placeId,
        placeName: '학생식당',
        categoryName: '한식',
        address: '광주광역시 테스트로 100',
        content: content,
        reviewedAt: null,
      ),
    );
  }

  @override
  Future<List<MyReviewEntity>> getMyReviews() async =>
      List<MyReviewEntity>.of(_myReviews);

  @override
  Future<int> getMyReviewCount() async => _myReviews.length;
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

class _EmptyHotPlaceRepository extends _FakeRecommendedPlaceRepository {
  _EmptyHotPlaceRepository()
      : super(const [
          RecommendedPlaceEntity(
            placeId: 88,
            placeName: '대체 인기 장소',
            category: '카페',
            address: '광주광역시 테스트로 88',
            coordinate: MapCoordinate(latitude: 35.13, longitude: 126.89),
            reviewCount: 2,
            recommendCount: 7,
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
    return const [];
  }
}

class _ReviewCountMismatchRepository extends _FakeRecommendedPlaceRepository {
  _ReviewCountMismatchRepository() : super(const []);

  @override
  Future<List<MyReviewEntity>> getMyReviews() async => const [
        MyReviewEntity(
          reviewId: 41,
          placeId: 401,
          placeName: '학생식당',
          categoryName: '한식',
          address: '광주광역시 테스트로 41',
          content: '리뷰 있음',
          reviewedAt: null,
        ),
      ];

  @override
  Future<int> getMyReviewCount() async => 0;
}
