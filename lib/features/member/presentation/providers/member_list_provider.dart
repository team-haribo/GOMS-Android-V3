import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';

final memberListProvider =
    AsyncNotifierProvider<MemberListNotifier, List<MemberEntity>>(
  MemberListNotifier.new,
);

class MemberListNotifier extends AsyncNotifier<List<MemberEntity>> {
  @override
  Future<List<MemberEntity>> build() async {
    return _fetchMembers();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchMembers);
  }

  Future<List<MemberEntity>> _fetchMembers() async {
    try {
      return await ref.read(memberRepositoryProvider).getMembers();
    } on DioException catch (error) {
      throw MemberListException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const MemberListException('멤버 정보를 불러오지 못했습니다.');
    }
  }
}

class MemberListException implements Exception {
  const MemberListException(this.message);

  final String message;
}
