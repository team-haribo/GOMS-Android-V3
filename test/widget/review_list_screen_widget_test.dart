import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/review/ui/screens/review_list_screen.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets(
      'ReviewListScreen shows delete for my review and report for others', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendedPlaceRepositoryProvider.overrideWithValue(
            _FakeRecommendedPlaceRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
            ],
          ),
          home: const ReviewListScreen(
            placeId: 7,
            placeName: '학생식당',
            category: '한식',
            address: '광주광역시 테스트로 7',
            distanceMeter: 339,
            durationMinutes: 4,
            review: 2,
            recommended: 3,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('내가 쓴 후기'), findsOneWidget);
    expect(find.text('다른 사람이 쓴 후기'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader.toString().contains('assets/icons/report.svg'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/icons/bin.png',
      ),
      findsOneWidget,
    );
  });
}

class _FakeRecommendedPlaceRepository implements RecommendedPlaceRepository {
  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {}

  @override
  Future<void> deleteReview(int reviewId) async {}

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
        coordinate: const MapCoordinate(latitude: 35.1, longitude: 126.9),
      );

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async =>
      <PlaceReviewEntity>[
        PlaceReviewEntity(
          reviewId: 1,
          name: '홍길동',
          grade: 2,
          department: 'SW',
          profileImageUrl: '',
          content: '내가 쓴 후기',
          reviewedAt: DateTime(2026, 4, 21),
        ),
        PlaceReviewEntity(
          reviewId: 2,
          name: '김철수',
          grade: 1,
          department: 'AI',
          profileImageUrl: '',
          content: '다른 사람이 쓴 후기',
          reviewedAt: DateTime(2026, 4, 20),
        ),
      ];

  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async => const [];

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async =>
      const [];

  @override
  Future<int> getMyReviewCount() async => 1;

  @override
  Future<List<MyReviewEntity>> getMyReviews() async => <MyReviewEntity>[
        const MyReviewEntity(
          reviewId: 1,
          placeId: 7,
          placeName: '학생식당',
          categoryName: '한식',
          address: '광주광역시 테스트로 7',
          content: '내가 쓴 후기',
          reviewedAt: null,
        ),
      ];

  @override
  Future<int> getRecommendedPlacesCount() async => 0;

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async => const [];

  @override
  Future<bool> recommendPlace(int placeId) async => true;

  @override
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword) async =>
      const [];

  @override
  Future<bool> unRecommendPlace(int placeId) async => false;
}
