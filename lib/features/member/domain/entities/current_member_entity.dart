import 'package:goms/core/enums/role_enum.dart';

class CurrentMemberEntity {
  const CurrentMemberEntity({
    required this.memberId,
    required this.email,
    required this.name,
    required this.role,
  });

  final int memberId;
  final String email;
  final String name;
  final RoleEnum role;
}
