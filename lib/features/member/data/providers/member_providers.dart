import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/member/data/datasources/member_remote_datasource.dart';
import 'package:goms/features/member/data/repositories/member_repository.dart';
import 'package:goms/features/member/data/repositories/member_repository_impl.dart';

final memberRemoteDataSourceProvider = Provider<MemberRemoteDataSource>((ref) {
  return MemberRemoteDataSource(ref.watch(dioProvider));
});

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(ref.watch(memberRemoteDataSourceProvider));
});
