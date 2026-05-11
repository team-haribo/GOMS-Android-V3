import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/late/data/datasources/late_remote_datasource.dart';

final lateRemoteDataSourceProvider = Provider<LateRemoteDataSource>((ref) {
  return LateRemoteDataSource(ref.watch(dioProvider));
});
