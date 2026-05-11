import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/auth/session/data/datasources/session_remote_datasource.dart';

final sessionRemoteDataSourceProvider =
    Provider<SessionRemoteDataSource>((ref) {
  return SessionRemoteDataSource(ref.watch(dioProvider));
});
