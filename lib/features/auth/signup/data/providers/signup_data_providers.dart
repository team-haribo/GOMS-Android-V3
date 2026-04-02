import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/auth/signup/data/datasources/signup_remote_datasource.dart';
import 'package:goms/features/auth/signup/data/repositories/signup_repository_impl.dart';
import 'package:goms/features/auth/signup/domain/repositories/signup_repository.dart';

final signupRemoteDataSourceProvider = Provider<SignupRemoteDataSource>((ref) {
  return SignupRemoteDataSource(ref.watch(dioProvider));
});

final signupRepositoryProvider = Provider<SignupRepository>((ref) {
  return SignupRepositoryImpl(
    remoteDataSource: ref.watch(signupRemoteDataSourceProvider),
  );
});
