class LateRankStudentEntity {
  const LateRankStudentEntity({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    this.profileImageUrl = '',
    required this.comingAt,
  });

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final String profileImageUrl;
  final DateTime comingAt;
}
