import 'package:goms/features/map/review/domain/enums/report_status.dart';

class ReportDetailEntity {
  const ReportDetailEntity({
    required this.reportId,
    required this.reviewId,
    required this.reviewerMemberId,
    required this.reviewerName,
    required this.reviewerGrade,
    required this.reviewerDepartment,
    this.reviewerProfileImageUrl = '',
    required this.reviewContent,
    required this.reportContent,
    required this.reportStatus,
    this.reviewCreatedAt,
    this.reportCreatedAt,
    this.deletedAt,
    this.deletedBy,
  });

  final int reportId;
  final int reviewId;
  final int reviewerMemberId;
  final String reviewerName;
  final int reviewerGrade;
  final String reviewerDepartment;
  final String reviewerProfileImageUrl;
  final String reviewContent;
  final String reportContent;
  final ReportStatus reportStatus;
  final DateTime? reviewCreatedAt;
  final DateTime? reportCreatedAt;
  final DateTime? deletedAt;
  final String? deletedBy;
}
