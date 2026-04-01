import 'package:goms/features/member/domain/entities/member_entity.dart';

enum MemberListStatus { loading, success, error }

class MemberListState {
  const MemberListState({
    required this.status,
    required this.members,
    this.errorMessage,
  });

  const MemberListState.loading()
      : status = MemberListStatus.loading,
        members = const [],
        errorMessage = null;

  const MemberListState.success(this.members)
      : status = MemberListStatus.success,
        errorMessage = null;

  const MemberListState.error(this.errorMessage)
      : status = MemberListStatus.error,
        members = const [];

  final MemberListStatus status;
  final List<MemberEntity> members;
  final String? errorMessage;
}
