class MemberEntity {
  const MemberEntity({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.role,
    required this.profileImageUrl,
  });

  final int id;
  final String name;
  final String studentNumber;
  final String role;
  final String profileImageUrl;
}
