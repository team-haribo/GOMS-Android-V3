import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';

class GetMyRoleUseCase {
  const GetMyRoleUseCase(this._repository);

  final MemberRepository _repository;

  Future<CurrentMemberEntity> call() {
    return _repository.getMyRole();
  }
}
