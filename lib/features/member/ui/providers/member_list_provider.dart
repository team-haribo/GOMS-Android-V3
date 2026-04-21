import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/ui/models/member_model.dart';

final memberListProvider =
    AsyncNotifierProvider<MemberListNotifier, List<MemberModel>>(
  MemberListNotifier.new,
);

class MemberListNotifier extends AsyncNotifier<List<MemberModel>> {
  @override
  Future<List<MemberModel>> build() async {
    return _fetchMembers();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchMembers);
  }

  Future<List<MemberModel>> _fetchMembers() async {
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
