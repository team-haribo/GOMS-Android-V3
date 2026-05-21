import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/utils/logger.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/map/data/datasources/recommended_place_remote_datasource.dart';
import 'package:goms/features/map/data/repositories/recommended_place_repository_impl.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/domain/repositories/recommended_place_repository.dart';

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

final recommendedPlacesCountProvider = FutureProvider<int>((ref) async {
  return ref
      .read(recommendedPlaceRepositoryProvider)
      .getRecommendedPlacesCount();
});

final recommendedPlacesProvider =
    FutureProvider<List<RecommendedPlaceEntity>>((ref) async {
  return ref.read(recommendedPlaceRepositoryProvider).getRecommendedPlaces();
});

final recommendedPlacesCacheProvider = NotifierProvider<
    RecommendedPlacesCacheNotifier, RecommendedPlacesCacheState>(
  RecommendedPlacesCacheNotifier.new,
);

@immutable
class RecommendedPlacesCacheState {
  const RecommendedPlacesCacheState({
    this.places = const <RecommendedPlaceEntity>[],
    this.count = 0,
    this.isLoading = false,
  });

  final List<RecommendedPlaceEntity> places;
  final int count;
  final bool isLoading;

  RecommendedPlacesCacheState copyWith({
    List<RecommendedPlaceEntity>? places,
    int? count,
    bool? isLoading,
  }) {
    return RecommendedPlacesCacheState(
      places: places ?? this.places,
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RecommendedPlacesCacheNotifier
    extends Notifier<RecommendedPlacesCacheState> {
  @override
  RecommendedPlacesCacheState build() => const RecommendedPlacesCacheState();

  Future<void> refresh() async {
    if (!ref.mounted) {
      return;
    }

    if (state.places.isEmpty && !state.isLoading) {
      state = state.copyWith(isLoading: true);
    }

    try {
      final repository = ref.read(recommendedPlaceRepositoryProvider);
      final places = await repository.getRecommendedPlaces();
      final count = await repository.getRecommendedPlacesCount();

      if (!ref.mounted) {
        return;
      }

      if (!listEquals(state.places, places) ||
          state.count != count ||
          state.isLoading) {
        state = RecommendedPlacesCacheState(
          places: places,
          count: count,
        );
      }
    } catch (error, stackTrace) {
      if (!ref.mounted) {
        return;
      }

      Logger.e(
        'Recommended places refresh failed.',
        tag: 'MAP',
        error: error,
        stackTrace: stackTrace,
      );

      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }
}

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

final myReviewIdsProvider = FutureProvider<Set<int>>((ref) async {
  final reviews =
      await ref.read(recommendedPlaceRepositoryProvider).getMyReviews();
  return reviews.map((review) => review.reviewId).toSet();
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
