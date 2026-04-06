class StudentCouncilFilterRequest {
  const StudentCouncilFilterRequest({
    this.name,
    this.grade,
    this.department,
    this.gender,
    this.status,
    this.role,
  });

  final String? name;
  final int? grade;
  final String? department;
  final String? gender;
  final String? status;
  final String? role;

  Map<String, dynamic> toQueryParameters() {
    return {
      if (name != null && name!.trim().isNotEmpty) 'name': name!.trim(),
      if (grade != null) 'grade': grade,
      if (department != null && department!.isNotEmpty)
        'department': department,
      if (gender != null && gender!.isNotEmpty) 'gender': gender,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (role != null && role!.isNotEmpty) 'role': role,
    };
  }

  bool get isEmpty => toQueryParameters().isEmpty;
}
