import 'package:goms/features/member/domain/entities/member_entity.dart';

abstract class MemberRepository {
  Future<List<MemberEntity>> getMembers();
  Future<void> withdrawMember({required String password});
}
