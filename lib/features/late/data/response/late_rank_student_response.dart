import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';

class LateRankStudentResponse {
  const LateRankStudentResponse({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.profileImageUrl,
    required this.comingAt,
  });

  factory LateRankStudentResponse.fromJson(Map<String, dynamic> json) {
    return LateRankStudentResponse(
      memberId: json['memberId'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      grade: json['grade'] as int? ?? 0,
      department: json['department'] as String? ?? '',
      profileImageUrl: (json['profileImageUrl'] ?? json['profileUrl']) as String? ?? '',
      comingAt:
          DateTime.tryParse(json['comingAt'] as String? ?? '') ?? DateTime(0),
    );
  }

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final String profileImageUrl;
  final DateTime comingAt;

  LateRankStudentEntity toEntity() {
    return LateRankStudentEntity(
      memberId: memberId,
      name: name,
      grade: grade,
      department: department,
      profileImageUrl: profileImageUrl,
      comingAt: comingAt,
    );
  }
}
