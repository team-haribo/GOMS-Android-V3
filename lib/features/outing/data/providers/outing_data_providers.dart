import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/outing/data/datasources/outing_remote_datasource.dart';
import 'package:goms/features/outing/data/repositories/outing_repository_impl.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';
import 'package:goms/features/outing/domain/usecases/get_current_outing_students_usecase.dart';
import 'package:goms/features/outing/domain/usecases/get_my_outing_status_usecase.dart';
import 'package:goms/features/outing/domain/usecases/process_coming_by_qr_usecase.dart';
import 'package:goms/features/outing/domain/usecases/process_outing_by_qr_usecase.dart';
import 'package:goms/features/outing/domain/usecases/search_outing_students_usecase.dart';

final outingRemoteDataSourceProvider = Provider<OutingRemoteDataSource>((ref) {
  return OutingRemoteDataSource(ref.watch(dioProvider));
});

final outingRepositoryProvider = Provider<OutingRepository>((ref) {
  return OutingRepositoryImpl(
    remoteDataSource: ref.watch(outingRemoteDataSourceProvider),
  );
});

final getMyOutingStatusUseCaseProvider = Provider<GetMyOutingStatusUseCase>((
  ref,
) {
  return GetMyOutingStatusUseCase(ref.watch(outingRepositoryProvider));
});

final getCurrentOutingStudentsUseCaseProvider =
    Provider<GetCurrentOutingStudentsUseCase>((ref) {
  return GetCurrentOutingStudentsUseCase(ref.watch(outingRepositoryProvider));
});

final processOutingByQrUseCaseProvider = Provider<ProcessOutingByQrUseCase>((
  ref,
) {
  return ProcessOutingByQrUseCase(ref.watch(outingRepositoryProvider));
});

final processComingByQrUseCaseProvider = Provider<ProcessComingByQrUseCase>((
  ref,
) {
  return ProcessComingByQrUseCase(ref.watch(outingRepositoryProvider));
});

final searchOutingStudentsUseCaseProvider =
    Provider<SearchOutingStudentsUseCase>((ref) {
  return SearchOutingStudentsUseCase(ref.watch(outingRepositoryProvider));
});
