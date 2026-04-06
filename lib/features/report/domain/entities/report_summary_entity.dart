import 'package:goms/features/map/review/domain/enums/report_status.dart';

class ReportSummaryEntity {
  const ReportSummaryEntity({
    required this.reportId,
    required this.reviewId,
    required this.reviewerMemberId,
    required this.reviewerName,
    required this.reviewerGrade,
    required this.reviewerDepartment,
    required this.reportCreatedAt,
    required this.reportStatus,
    this.deletedAt,
    this.deletedBy,
  });

  final int reportId;
  final int reviewId;
  final int reviewerMemberId;
  final String reviewerName;
  final int reviewerGrade;
  final String reviewerDepartment;
  final DateTime? reportCreatedAt;
  final ReportStatus reportStatus;
  final DateTime? deletedAt;
  final String? deletedBy;
}
