import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/member/data/datasources/member_remote_datasource.dart';
import 'package:goms/features/member/data/repositories/member_repository_impl.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';
import 'package:goms/features/member/domain/usecases/get_members_usecase.dart';
import 'package:goms/features/member/domain/usecases/get_my_role_usecase.dart';
import 'package:goms/features/member/domain/usecases/withdraw_member_usecase.dart';

final memberRemoteDataSourceProvider = Provider<MemberRemoteDataSource>((ref) {
  return MemberRemoteDataSource(ref.watch(dioProvider));
});

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(ref.watch(memberRemoteDataSourceProvider));
});

final getMembersUseCaseProvider = Provider<GetMembersUseCase>((ref) {
  return GetMembersUseCase(ref.watch(memberRepositoryProvider));
});

final getMyRoleUseCaseProvider = Provider<GetMyRoleUseCase>((ref) {
  return GetMyRoleUseCase(ref.watch(memberRepositoryProvider));
});

final withdrawMemberUseCaseProvider = Provider<WithdrawMemberUseCase>((ref) {
  return WithdrawMemberUseCase(ref.watch(memberRepositoryProvider));
});
