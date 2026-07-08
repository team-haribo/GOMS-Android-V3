import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/auth/signup/data/datasources/signup_remote_datasource.dart';

final signupRemoteDataSourceProvider = Provider<SignupRemoteDataSource>((ref) {
  return SignupRemoteDataSource(ref.watch(dioProvider));
});
