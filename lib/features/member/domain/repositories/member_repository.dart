import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';

abstract class MemberRepository {
  Future<List<MemberEntity>> getMembers();
  Future<CurrentMemberEntity> getMyRole();
  Future<void> withdrawMember({required String password});
}
