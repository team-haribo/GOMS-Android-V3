import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/map/data/datasources/recommended_place_remote_datasource.dart';
import 'package:goms/features/map/data/repositories/recommended_place_repository_impl.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';
import 'package:goms/features/map/domain/usecases/get_recommended_places_usecase.dart';

final recommendedPlaceRemoteDataSourceProvider =
    Provider<RecommendedPlaceRemoteDataSource>((ref) {
  return RecommendedPlaceRemoteDataSource(ref.watch(dioProvider));
});

final recommendedPlaceRepositoryProvider =
    Provider<RecommendedPlaceRepository>((ref) {
  return RecommendedPlaceRepositoryImpl(
    ref.watch(recommendedPlaceRemoteDataSourceProvider),
  );
});

final getRecommendedPlacesUseCaseProvider =
    Provider<GetRecommendedPlacesUseCase>((ref) {
  return GetRecommendedPlacesUseCase(
    ref.watch(recommendedPlaceRepositoryProvider),
  );
});

final recommendedPlacesCountProvider = FutureProvider<int>((ref) async {
  return ref
      .read(recommendedPlaceRepositoryProvider)
      .getRecommendedPlacesCount();
});

final recommendedPlacesProvider =
    FutureProvider<List<RecommendedPlaceEntity>>((ref) async {
  return ref.read(recommendedPlaceRepositoryProvider).getRecommendedPlaces();
});

final allPlacesProvider = FutureProvider<List<RecommendedPlaceEntity>>(
  (ref) async {
    return ref.read(recommendedPlaceRepositoryProvider).getPlaces();
  },
);

final placeDetailProvider =
    FutureProvider.family<RecommendedPlaceEntity, int>((ref, placeId) async {
  return ref.read(recommendedPlaceRepositoryProvider).getPlaceDetail(placeId);
});

final placeReviewsProvider =
    FutureProvider.family<List<PlaceReviewEntity>, int>((ref, placeId) async {
  return ref.read(recommendedPlaceRepositoryProvider).getPlaceReviews(placeId);
});

final placeSearchKeywordProvider = StateProvider<String>((ref) => '');

final placeSearchResultsProvider =
    FutureProvider.autoDispose<List<RecommendedPlaceEntity>>((ref) async {
  final keyword = ref.watch(placeSearchKeywordProvider).trim();
  if (keyword.isEmpty) {
    return const <RecommendedPlaceEntity>[];
  }

  return ref.read(recommendedPlaceRepositoryProvider).searchPlaces(keyword);
});
