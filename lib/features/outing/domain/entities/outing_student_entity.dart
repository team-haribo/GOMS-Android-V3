class OutingStudentEntity {
  const OutingStudentEntity({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.outingAt,
  });

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final DateTime outingAt;
}
