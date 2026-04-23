class StudentInfoFormatter {
  const StudentInfoFormatter._();

  static String formatCohortDepartment({
    required int grade,
    required String department,
  }) {
    return '$grade기 | ${formatDepartment(department)}';
  }

  static String formatDepartment(String department) {
    final trimmedDepartment = department.trim();
    if (trimmedDepartment.isEmpty) {
      return trimmedDepartment;
    }

    return trimmedDepartment.endsWith('과')
        ? trimmedDepartment
        : '$trimmedDepartment과';
  }
}
