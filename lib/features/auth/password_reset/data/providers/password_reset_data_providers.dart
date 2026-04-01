import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/auth/password_reset/data/datasources/password_reset_remote_datasource.dart';
import 'package:goms/features/auth/password_reset/data/repositories/password_reset_repository_impl.dart';
import 'package:goms/features/auth/password_reset/domain/repositories/password_reset_repository.dart';

final passwordResetRemoteDataSourceProvider =
    Provider<PasswordResetRemoteDataSource>((ref) {
  return PasswordResetRemoteDataSource(ref.watch(dioProvider));
});

final passwordResetRepositoryProvider =
    Provider<PasswordResetRepository>((ref) {
  return PasswordResetRepositoryImpl(
    remoteDataSource: ref.watch(passwordResetRemoteDataSourceProvider),
  );
});
