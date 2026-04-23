import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/ui/models/map_screen_state.dart';
import 'package:goms/features/map/discovery/ui/providers/map_screen_provider.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';
import 'package:goms/features/map/review/ui/models/write_review_state.dart';
import 'package:goms/features/map/review/ui/providers/write_review_provider.dart';

void main() {
  test('review submission refreshes main bottom sheet activity immediately',
      () async {
    final repository = _ReviewCreatingRepository();
    final container = ProviderContainer(
      overrides: [
        recommendedPlaceRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(mapScreenProvider.notifier).fetchData();
    expect(container.read(mapScreenProvider).reviewCount, 0);

    final recommendedPlacesSubscription = container.listen(
      recommendedPlacesProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(recommendedPlacesSubscription.close);
    final initialRecommendedPlaces =
        await container.read(recommendedPlacesProvider.future);
    expect(initialRecommendedPlaces.single.reviewCount, 0);

    final notifier = container.read(writeReviewProvider.notifier);
    notifier.onTextChanged('새 후기입니다');

    await notifier.submitReview(
      placeId: 1,
      placeName: '학생식당',
      category: '한식',
      address: '광주광역시 테스트로 1',
      review: 0,
      recommended: 0,
    );

    final writeState = container.read(writeReviewProvider);
    final mapState = container.read(mapScreenProvider);

    expect(writeState.status, WriteReviewStatus.success);
    expect(repository.createdReviewContents, ['새 후기입니다']);
    expect(mapState.status, MapScreenStatus.success);
    expect(mapState.reviewCount, 1);
    expect(mapState.reviewModels, hasLength(1));
    expect(mapState.reviewModels.single.reviewDetailContent, '새 후기입니다');
    expect(mapState.popularPlaces.single.review, 1);

    final refreshedRecommendedPlaces =
        await container.read(recommendedPlacesProvider.future);
    expect(refreshedRecommendedPlaces.single.reviewCount, 1);
  });
}

class _ReviewCreatingRepository implements RecommendedPlaceRepository {
  final List<MyReviewEntity> _myReviews = <MyReviewEntity>[];
  final List<String> createdReviewContents = <String>[];

  @override
  Future<void> createReview({
    required int placeId,
    required String content,
  }) async {
    createdReviewContents.add(content);
    _myReviews.add(
      MyReviewEntity(
        reviewId: 100 + _myReviews.length,
        placeId: placeId,
        placeName: '학생식당',
        categoryName: '한식',
        address: '광주광역시 테스트로 1',
        content: content,
        reviewedAt: DateTime(2026, 4, 23),
      ),
    );
  }

  @override
  Future<void> deleteReview(int reviewId) async {}

  @override
  Future<List<RecommendedPlaceEntity>> getHotPlaces({int? days}) async => [
        _place,
      ];

  @override
  Future<List<MyReviewEntity>> getMyReviews() async =>
      List<MyReviewEntity>.of(_myReviews);

  @override
  Future<int> getMyReviewCount() async => _myReviews.length;

  @override
  Future<RecommendedPlaceEntity> getPlaceDetail(int placeId) async => _place;

  @override
  Future<List<PlaceReviewEntity>> getPlaceReviews(int placeId) async =>
      _myReviews
          .map(
            (review) => PlaceReviewEntity(
              reviewId: review.reviewId,
              name: '나',
              grade: 3,
              department: 'SW',
              profileImageUrl: '',
              content: review.content,
              reviewedAt: review.reviewedAt,
            ),
          )
          .toList(growable: false);

  @override
  Future<List<RecommendedPlaceEntity>> getPlaces() async => [_place];

  @override
  Future<List<RecommendedPlaceEntity>> getRecommendedPlaces() async => [_place];

  @override
  Future<int> getRecommendedPlacesCount() async => 0;

  @override
  Future<bool> recommendPlace(int placeId) async => true;

  @override
  Future<List<RecommendedPlaceEntity>> searchPlaces(String keyword) async => [
        _place,
      ];

  @override
  Future<bool> unRecommendPlace(int placeId) async => false;

  RecommendedPlaceEntity get _place => RecommendedPlaceEntity(
        placeId: 1,
        placeName: '학생식당',
        category: '한식',
        address: '광주광역시 테스트로 1',
        coordinate: const MapCoordinate(latitude: 35.1, longitude: 126.9),
        reviewCount: _myReviews.length,
        recommendCount: 0,
        recommended: false,
      );
}
