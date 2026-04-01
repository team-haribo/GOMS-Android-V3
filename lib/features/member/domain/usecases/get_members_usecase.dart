import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';

class GetMembersUseCase {
  const GetMembersUseCase(this._repository);

  final MemberRepository _repository;

  Future<List<MemberEntity>> call() {
    return _repository.getMembers();
  }
}
