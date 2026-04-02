import 'package:goms/features/member/domain/entities/member_entity.dart';

class MemberDto {
  const MemberDto({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.role,
    required this.profileImageUrl,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    return MemberDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      studentNumber: json['studentNumber'] as String? ?? '',
      role: json['role'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
    );
  }

  final int id;
  final String name;
  final String studentNumber;
  final String role;
  final String profileImageUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'studentNumber': studentNumber,
      'role': role,
      'profileImageUrl': profileImageUrl,
    };
  }

  MemberEntity toEntity() {
    return MemberEntity(
      id: id,
      name: name,
      studentNumber: studentNumber,
      role: role,
      profileImageUrl: profileImageUrl,
    );
  }
}
