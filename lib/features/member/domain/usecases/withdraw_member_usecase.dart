import 'package:goms/features/member/domain/repositories/member_repository.dart';

class WithdrawMemberUseCase {
  const WithdrawMemberUseCase(this._repository);

  final MemberRepository _repository;

  Future<void> call({required String password}) {
    return _repository.withdrawMember(password: password);
  }
}
