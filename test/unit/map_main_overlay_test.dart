import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';
import 'package:goms/features/map/shared/ui/widgets/map_main_overlay.dart';

void main() {
  testWidgets('tapping a place card forwards the selected place callback', (
    tester,
  ) async {
    const place = PopularPlace(
      placeId: 7,
      name: '학생식당',
      category: '한식',
      address: '광주광역시 테스트로 7',
      review: 2,
      recommended: 3,
      coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
    );

    PopularPlace? tappedPlace;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(
            const _FakeRecommendedPlaceRepository(),
          ),
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
          home: Scaffold(
            body: MapMainOverlay(
              state: const MapScreenState(
                status: MapScreenStatus.success,
                popularPlaces: [place],
              ),
              onPlaceTap: (value) => tappedPlace = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('학생식당'));
    await tester.pump();

    expect(tappedPlace, place);
  });

  testWidgets('selected place shows detail sheet UI instead of detail button', (
    tester,
  ) async {
    const place = PopularPlace(
      placeId: 7,
      name: '학생식당',
      category: '한식',
      address: '광주광역시 테스트로 7',
      review: 2,
      recommended: 3,
      coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
      distanceMeters: 339,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(
            const _FakeRecommendedPlaceRepository(),
          ),
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
          home: const Scaffold(
            body: MapMainOverlay(
              state: MapScreenState(status: MapScreenStatus.success),
              selectedPlace: place,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('자세히 보기'), findsNothing);
    expect(find.text('도착'), findsOneWidget);
    expect(find.text('출발'), findsOneWidget);
    expect(find.text('학생 후기'), findsOneWidget);
    expect(find.text('후기 남기기'), findsOneWidget);
    expect(find.textContaining('339m |'), findsOneWidget);
  });
}

class _FakeRecommendedPlaceRepository implements RecommendedPlaceRepository {
  const _FakeRecommendedPlaceRepository();

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {}

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
  Future<List<RecommendedPlaceEntity>> getPlaces() async => const [];

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async =>
      const [];

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async =>
      const [];

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async => const [];

  @override
  Future<int> getRecommendedPlacesCount() async => 0;

  @override
  Future<bool> recommendPlace(int placeId) async => false;

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
