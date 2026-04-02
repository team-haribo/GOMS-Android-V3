import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/late/data/datasources/late_remote_datasource.dart';
import 'package:goms/features/late/data/repositories/late_repository_impl.dart';
import 'package:goms/features/late/domain/repositories/late_repository.dart';
import 'package:goms/features/late/domain/usecases/get_late_rank_students_usecase.dart';

final lateRemoteDataSourceProvider = Provider<LateRemoteDataSource>((ref) {
  return LateRemoteDataSource(ref.watch(dioProvider));
});

final lateRepositoryProvider = Provider<LateRepository>((ref) {
  return LateRepositoryImpl(ref.watch(lateRemoteDataSourceProvider));
});

final getLateRankStudentsUseCaseProvider =
    Provider<GetLateRankStudentsUseCase>((ref) {
  return GetLateRankStudentsUseCase(ref.watch(lateRepositoryProvider));
});
