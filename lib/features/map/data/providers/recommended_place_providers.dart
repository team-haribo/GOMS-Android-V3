import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/map/data/datasources/recommended_place_remote_datasource.dart';
import 'package:goms/features/map/data/repositories/recommended_place_repository_impl.dart';
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
