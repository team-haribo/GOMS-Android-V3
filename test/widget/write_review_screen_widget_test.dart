import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';
import 'package:goms/features/map/review/ui/screens/write_review_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('후기 남기기 하트는 추천 상태를 반영하고 해제할 수 있다', (tester) async {
    final repository = _FakeRecommendedPlaceRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
            ],
          ),
          home: const WriteReviewScreen(
            placeId: 10,
            placeName: '학생식당',
            category: '한식',
            address: '광주광역시 테스트로 10',
            review: 2,
            recommended: 3,
            isRecommended: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('학생 후기 2 | 추천 3'), findsOneWidget);
    expect(_findSvgAsset('assets/icons/heart_filled.svg'), findsOneWidget);

    await tester.tap(_findSvgAsset('assets/icons/heart_filled.svg'));
    await tester.pumpAndSettle();

    expect(repository.unRecommendedPlaceIds, [10]);
    expect(find.text('학생 후기 2 | 추천 2'), findsOneWidget);
    expect(_findSvgAsset('assets/icons/heart.svg'), findsOneWidget);
  });

  testWidgets('후기 남기기 하트는 추천할 수 있다', (tester) async {
    final repository = _FakeRecommendedPlaceRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
            ],
          ),
          home: const WriteReviewScreen(
            placeId: 10,
            placeName: '학생식당',
            category: '한식',
            address: '광주광역시 테스트로 10',
            review: 2,
            recommended: 3,
            isRecommended: false,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(_findSvgAsset('assets/icons/heart.svg'), findsOneWidget);

    await tester.tap(_findSvgAsset('assets/icons/heart.svg'));
    await tester.pumpAndSettle();

    expect(repository.recommendedPlaceIds, [10]);
    expect(find.text('학생 후기 2 | 추천 4'), findsOneWidget);
    expect(_findSvgAsset('assets/icons/heart_filled.svg'), findsOneWidget);
  });
}

Finder _findSvgAsset(String assetPath) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is SvgPicture && widget.bytesLoader.toString().contains(assetPath),
  );
}

class _FakeRecommendedPlaceRepository implements RecommendedPlaceRepository {
  final List<int> recommendedPlaceIds = <int>[];
  final List<int> unRecommendedPlaceIds = <int>[];

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {}

  @override
  Future<void> deleteReview(int reviewId) async {}

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async =>
      const [];

  @override
  Future<List<MyReviewEntity>> getMyReviews() async => const [];

  @override
  Future<int> getMyReviewCount() async => 0;

  @override
  Future<RecommendedPlaceEntity> getPlaceDetail(int placeId) async =>
      RecommendedPlaceEntity(
        placeId: placeId,
        placeName: '학생식당',
        category: '한식',
        address: '광주광역시 테스트로 10',
        coordinate: const MapCoordinate(latitude: 35.1, longitude: 126.9),
        reviewCount: 2,
        recommendCount: 3,
        recommended: false,
      );

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async =>
      const [];

  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async => const [];

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async =>
      const [];

  @override
  Future<int> getRecommendedPlacesCount() async => 0;

  @override
  Future<bool> recommendPlace(int placeId) async {
    recommendedPlaceIds.add(placeId);
    return true;
  }

  @override
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword) async =>
      const [];

  @override
  Future<bool> unRecommendPlace(int placeId) async {
    unRecommendedPlaceIds.add(placeId);
    return false;
  }
}
