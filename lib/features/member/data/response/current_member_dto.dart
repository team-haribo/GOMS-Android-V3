import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';

class CurrentMemberDto {
  const CurrentMemberDto({
    required this.memberId,
    required this.email,
    required this.name,
    required this.role,
  });

  factory CurrentMemberDto.fromJson(Map<String, dynamic> json) {
    return CurrentMemberDto(
      memberId: json['memberId'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: _toRoleEnum(json['role'] as String?),
    );
  }

  final int memberId;
  final String email;
  final String name;
  final RoleEnum role;

  CurrentMemberEntity toEntity() {
    return CurrentMemberEntity(
      memberId: memberId,
      email: email,
      name: name,
      role: role,
    );
  }

  static RoleEnum _toRoleEnum(String? role) {
    switch (role) {
      case 'ROLE_ADMIN':
        return RoleEnum.admin;
      case 'ROLE_STUDENT':
      default:
        return RoleEnum.user;
    }
  }
}
