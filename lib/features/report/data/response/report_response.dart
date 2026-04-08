import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/response/report_parsers.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';

class ReportResponse {
  const ReportResponse({
    required this.reportId,
    required this.reviewId,
    required this.reviewerMemberId,
    required this.reviewerName,
    required this.reviewerGrade,
    required this.reviewerDepartment,
    required this.reviewerProfileImageUrl,
    required this.reportCreatedAt,
    required this.reportStatus,
    this.deletedAt,
    this.deletedBy,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      reportId: parseReportInt(json['reportId']),
      reviewId: parseReportInt(json['reviewId']),
      reviewerMemberId: parseReportInt(json['reviewerMemberId']),
      reviewerName: parseReportString(json['reviewerName']),
      reviewerGrade: parseReportInt(json['reviewerGrade']),
      reviewerDepartment: parseReportString(json['reviewerDepartment']),
      reviewerProfileImageUrl:
        (json['reviewerProfileImageUrl'] ??
            json['reviewerProfileUrl'] ??
            json['profileImageUrl'] ??
        json['profileUrl']) as String? ?? '',
      reportCreatedAt: parseReportDateTime(json['reportCreatedAt']),
      reportStatus: parseReportStatus(json['reportStatus']),
      deletedAt: parseReportDateTime(json['deletedAt']),
      deletedBy: parseNullableReportString(json['deletedBy']),
    );
  }

  final int reportId;
  final int reviewId;
  final int reviewerMemberId;
  final String reviewerName;
  final int reviewerGrade;
  final String reviewerDepartment;
  final String reviewerProfileImageUrl;
  final DateTime? reportCreatedAt;
  final ReportStatus reportStatus;
  final DateTime? deletedAt;
  final String? deletedBy;

  ReportSummaryEntity toEntity() {
    return ReportSummaryEntity(
      reportId: reportId,
      reviewId: reviewId,
      reviewerMemberId: reviewerMemberId,
      reviewerName: reviewerName,
      reviewerGrade: reviewerGrade,
      reviewerDepartment: reviewerDepartment,
      reviewerProfileImageUrl: reviewerProfileImageUrl,
      reportCreatedAt: reportCreatedAt,
      reportStatus: reportStatus,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
    );
  }
}
