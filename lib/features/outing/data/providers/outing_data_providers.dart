import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/outing/data/datasources/outing_remote_datasource.dart';
import 'package:goms/features/outing/data/repositories/outing_repository_impl.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

final outingRemoteDataSourceProvider = Provider<OutingRemoteDataSource>((ref) {
  return OutingRemoteDataSource(ref.watch(dioProvider));
});

final outingRepositoryProvider = Provider<OutingRepository>((ref) {
  return OutingRepositoryImpl(
    remoteDataSource: ref.watch(outingRemoteDataSourceProvider),
  );
});
