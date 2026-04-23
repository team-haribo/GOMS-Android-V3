import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/direction/ui/models/direction_state.dart';
import 'package:goms/features/map/direction/ui/providers/direction_provider.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/discovery/ui/providers/map_screen_provider.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';
import 'package:goms/features/map/shared/ui/models/map_screen_type.dart';
import 'package:goms/features/map/shared/ui/screens/map_base_screen.dart';
import 'package:goms/features/map/shared/ui/widgets/kakao_map_background.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  const searchedPlace = PopularPlace(
    placeId: 1,
    name: '검색 장소',
    category: '카페',
    address: '광주광역시 테스트로 1',
    review: 4,
    recommended: 8,
    coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
  );
  const markerPlace = PopularPlace(
    placeId: 2,
    name: '마커 장소',
    category: '한식',
    address: '광주광역시 테스트로 2',
    review: 1,
    recommended: 3,
    coordinate: MapCoordinate(latitude: 35.2, longitude: 126.8),
  );
  const popularPlace = PopularPlace(
    placeId: 3,
    name: '인기 장소',
    category: '편의점',
    address: '광주광역시 테스트로 3',
    review: 2,
    recommended: 5,
    coordinate: MapCoordinate(latitude: 35.3, longitude: 126.7),
  );

  group('resolveCandidatePlaces', () {
    test('메인 화면에서는 검색 결과를 우선 사용한다', () {
      final places = resolveCandidatePlaces(
        type: MapScreenType.main,
        routePlace: null,
        searchedPlaces: const [searchedPlace],
        markerPlaces: const [markerPlace],
        popularPlaces: const [popularPlace],
      );

      expect(places, const [searchedPlace]);
    });

    test('상세 화면에서는 전달된 장소만 사용한다', () {
      final places = resolveCandidatePlaces(
        type: MapScreenType.detail,
        routePlace: popularPlace,
        searchedPlaces: const [searchedPlace],
        markerPlaces: const [markerPlace],
        popularPlaces: const [popularPlace],
      );

      expect(places, const [popularPlace]);
    });
  });

  group('resolveVisiblePlaces', () {
    test('메인 화면 첫 진입 시에는 라벨을 노출하지 않는다', () {
      final places = resolveVisiblePlaces(
        type: MapScreenType.main,
        routePlace: null,
        selectedPlace: null,
        popularPlaces: const [popularPlace],
      );

      expect(places, isEmpty);
    });

    test('메인 화면에서 장소를 선택하면 해당 장소 라벨만 노출한다', () {
      final places = resolveVisiblePlaces(
        type: MapScreenType.main,
        routePlace: null,
        selectedPlace: searchedPlace,
        popularPlaces: const [popularPlace],
      );

      expect(places, const [searchedPlace]);
    });

    test('상세 화면에서는 전달된 장소를 계속 노출한다', () {
      final places = resolveVisiblePlaces(
        type: MapScreenType.detail,
        routePlace: popularPlace,
        selectedPlace: searchedPlace,
        popularPlaces: const [markerPlace],
      );

      expect(places, const [popularPlace]);
    });
  });

  group('findNearestPlaceWithinRadius', () {
    test('반경 안에서 가장 가까운 장소를 반환한다', () {
      final place = findNearestPlaceWithinRadius(
        tapCoordinate:
            const MapCoordinate(latitude: 35.10001, longitude: 126.90001),
        places: const [searchedPlace, markerPlace],
        maxDistanceMeters: 80,
      );

      expect(place, searchedPlace);
    });

    test('반경 밖이면 null을 반환한다', () {
      final place = findNearestPlaceWithinRadius(
        tapCoordinate: const MapCoordinate(latitude: 35.5, longitude: 127.5),
        places: const [searchedPlace, markerPlace, popularPlace],
        maxDistanceMeters: 80,
      );

      expect(place, isNull);
    });
  });

  testWidgets('메인 화면에서 장소 선택 시 지도 마커도 같은 장소로 갱신된다', (tester) async {
    const place = PopularPlace(
      placeId: 7,
      name: '학생식당',
      category: '한식',
      address: '광주광역시 테스트로 7',
      review: 2,
      recommended: 3,
      coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(
            _FakeRecommendedPlaceRepository(
              hotPlaces: const [
                RecommendedPlaceEntity(
                  placeId: 7,
                  placeName: '학생식당',
                  category: '한식',
                  address: '광주광역시 테스트로 7',
                  reviewCount: 2,
                  recommendCount: 3,
                  recommended: false,
                  coordinate: MapCoordinate(
                    latitude: 35.1,
                    longitude: 126.9,
                  ),
                ),
              ],
            ),
          ),
          directionProvider.overrideWith(_FakeDirectionNotifier.new),
        ],
        child: MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
              Breakpoint(start: 360, end: 450, name: 'MOBILE'),
              Breakpoint(start: 451, end: 800, name: 'TABLET'),
              Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
            ],
          ),
          home: const MapBaseScreen(type: MapScreenType.main),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(
      tester.widget<KakaoMapBackground>(find.byType(KakaoMapBackground)).places,
      isEmpty,
    );

    await tester.tap(find.text('학생식당').first);
    await tester.pumpAndSettle();

    expect(
      tester.widget<KakaoMapBackground>(find.byType(KakaoMapBackground)).places,
      const [place],
    );
  });

  testWidgets('메인 화면에서 지도 이벤트가 발생하면 장소/활동 정보를 다시 불러온다', (tester) async {
    final repository = _FakeRecommendedPlaceRepository(
      hotPlaces: const [
        RecommendedPlaceEntity(
          placeId: 7,
          placeName: '학생식당',
          category: '한식',
          address: '광주광역시 테스트로 7',
          reviewCount: 2,
          recommendCount: 3,
          recommended: false,
          coordinate: MapCoordinate(
            latitude: 35.1,
            longitude: 126.9,
          ),
        ),
      ],
      recommendedPlaces: const [
        RecommendedPlaceEntity(
          placeId: 8,
          placeName: '추천 장소',
          category: '카페',
          address: '광주광역시 테스트로 8',
          reviewCount: 4,
          recommendCount: 9,
          recommended: true,
          coordinate: MapCoordinate(
            latitude: 35.2,
            longitude: 126.8,
          ),
        ),
      ],
      recommendedPlacesCount: 1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
          directionProvider.overrideWith(_FakeDirectionNotifier.new),
        ],
        child: MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
              Breakpoint(start: 360, end: 450, name: 'MOBILE'),
              Breakpoint(start: 451, end: 800, name: 'TABLET'),
              Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
            ],
          ),
          home: const MapBaseScreen(type: MapScreenType.main),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    final initialHotPlaceCalls = repository.getHotPlacesCallCount;
    final initialRecommendedCalls = repository.getRecommendedPlacesCallCount;
    final initialRecommendedCountCalls =
        repository.getRecommendedPlacesCountCallCount;
    final initialAllPlacesCalls = repository.getPlacesCallCount;

    tester
        .widget<KakaoMapBackground>(
          find.byType(KakaoMapBackground),
        )
        .onMapInteraction!
        .call();

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(repository.getHotPlacesCallCount, greaterThan(initialHotPlaceCalls));
    expect(
      repository.getRecommendedPlacesCallCount,
      greaterThan(initialRecommendedCalls),
    );
    expect(
      repository.getRecommendedPlacesCountCallCount,
      greaterThan(initialRecommendedCountCalls),
    );
    expect(repository.getPlacesCallCount, greaterThan(initialAllPlacesCalls));
  });

  testWidgets('메인 화면 재진입 시 장소/활동 정보만 다시 불러온다', (tester) async {
    final repository = _FakeRecommendedPlaceRepository(
      hotPlaces: const [
        RecommendedPlaceEntity(
          placeId: 7,
          placeName: '학생식당',
          category: '한식',
          address: '광주광역시 테스트로 7',
          reviewCount: 2,
          recommendCount: 3,
          recommended: false,
          coordinate: MapCoordinate(
            latitude: 35.1,
            longitude: 126.9,
          ),
        ),
      ],
      recommendedPlaces: const [
        RecommendedPlaceEntity(
          placeId: 8,
          placeName: '추천 장소',
          category: '카페',
          address: '광주광역시 테스트로 8',
          reviewCount: 4,
          recommendCount: 9,
          recommended: true,
          coordinate: MapCoordinate(
            latitude: 35.2,
            longitude: 126.8,
          ),
        ),
      ],
      recommendedPlacesCount: 1,
    );
    final container = ProviderContainer(
      overrides: [
        recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        directionProvider.overrideWith(_FakeDirectionNotifier.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
              Breakpoint(start: 360, end: 450, name: 'MOBILE'),
              Breakpoint(start: 451, end: 800, name: 'TABLET'),
              Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
            ],
          ),
          home: const MapBaseScreen(type: MapScreenType.main),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    final initialHotPlaceCalls = repository.getHotPlacesCallCount;
    final initialRecommendedCalls = repository.getRecommendedPlacesCallCount;
    final initialRecommendedCountCalls =
        repository.getRecommendedPlacesCountCallCount;
    final initialMyReviewCalls = repository.getMyReviewsCallCount;
    final initialAllPlacesCalls = repository.getPlacesCallCount;

    container.read(mapReentryRefreshSignalProvider.notifier).state++;
    await tester.pump();
    await tester.pump();

    expect(repository.getHotPlacesCallCount, greaterThan(initialHotPlaceCalls));
    expect(
      repository.getRecommendedPlacesCallCount,
      greaterThan(initialRecommendedCalls),
    );
    expect(
      repository.getRecommendedPlacesCountCallCount,
      greaterThan(initialRecommendedCountCalls),
    );
    expect(repository.getMyReviewsCallCount, greaterThan(initialMyReviewCalls));
    expect(repository.getPlacesCallCount, initialAllPlacesCalls);
  });
}

class _FakeRecommendedPlaceRepository implements RecommendedPlaceRepository {
  _FakeRecommendedPlaceRepository({
    this.hotPlaces = const [],
    this.recommendedPlaces = const [],
    this.recommendedPlacesCount = 0,
  });

  final List<RecommendedPlaceEntity> hotPlaces;
  final List<RecommendedPlaceEntity> recommendedPlaces;
  final int recommendedPlacesCount;
  int getPlacesCallCount = 0;
  int getHotPlacesCallCount = 0;
  int getRecommendedPlacesCallCount = 0;
  int getRecommendedPlacesCountCallCount = 0;
  int getMyReviewsCallCount = 0;

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {}

  @override
  Future<void> deleteReview(int reviewId) async {}

  @override
  Future<int> getMyReviewCount() async => 0;

  @override
  Future<List<MyReviewEntity>> getMyReviews() async {
    getMyReviewsCallCount += 1;
    return const [];
  }

  @override
  Future<RecommendedPlaceEntity> getPlaceDetail(int placeId) async =>
      RecommendedPlaceEntity(
        placeId: placeId,
        placeName: '학생식당',
        category: '한식',
        address: '광주광역시 테스트로 7',
        reviewCount: 2,
        recommendCount: 3,
        recommended: false,
      );

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async =>
      throw UnimplementedError();

  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async {
    getPlacesCallCount += 1;
    return hotPlaces;
  }

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async {
    getHotPlacesCallCount += 1;
    return hotPlaces;
  }

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async {
    getRecommendedPlacesCallCount += 1;
    return recommendedPlaces;
  }

  @override
  Future<int> getRecommendedPlacesCount() async {
    getRecommendedPlacesCountCallCount += 1;
    return recommendedPlacesCount;
  }

  @override
  Future<bool> recommendPlace(int placeId) async => false;

  @override
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword) async =>
      const [];

  @override
  Future<bool> unRecommendPlace(int placeId) async => false;
}

class _FakeDirectionNotifier extends DirectionNotifier {
  @override
  DirectionState build() => DirectionState.initial();
}
