import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/auth/session/data/datasources/session_remote_datasource.dart';
import 'package:goms/features/auth/session/data/repositories/session_repository_impl.dart';
import 'package:goms/features/auth/session/domain/repositories/session_repository.dart';

final sessionRemoteDataSourceProvider =
    Provider<SessionRemoteDataSource>((ref) {
  return SessionRemoteDataSource(ref.watch(dioProvider));
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(
    remoteDataSource: ref.watch(sessionRemoteDataSourceProvider),
  );
});
