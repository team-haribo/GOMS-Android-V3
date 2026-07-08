import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/auth/password_reset/data/datasources/password_reset_remote_datasource.dart';

final passwordResetRemoteDataSourceProvider =
    Provider<PasswordResetRemoteDataSource>((ref) {
  return PasswordResetRemoteDataSource(ref.watch(dioProvider));
});
