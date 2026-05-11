import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/qr/data/datasources/qr_remote_datasource.dart';

final qrRemoteDataSourceProvider = Provider<QrRemoteDataSource>((ref) {
  return QrRemoteDataSource(ref.watch(dioProvider));
});
