import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/auth/email_verification/data/datasources/email_verification_remote_datasource.dart';

final emailVerificationRemoteDataSourceProvider =
    Provider<EmailVerificationRemoteDataSource>((ref) {
  return EmailVerificationRemoteDataSource(ref.watch(dioProvider));
});
