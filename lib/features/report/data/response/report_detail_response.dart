import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/response/report_parsers.dart';
import 'package:goms/features/report/domain/entities/report_detail_entity.dart';

class ReportDetailResponse {
  const ReportDetailResponse({
    required this.reportId,
    required this.reviewId,
    required this.reviewCreatedAt,
    required this.reviewerMemberId,
    required this.reviewerName,
    required this.reviewerGrade,
    required this.reviewerDepartment,
    required this.reviewerProfileImageUrl,
    required this.reviewContent,
    required this.reportContent,
    required this.reportCreatedAt,
    required this.reportStatus,
    this.deletedAt,
    this.deletedBy,
  });

  factory ReportDetailResponse.fromJson(Map<String, dynamic> json) {
    return ReportDetailResponse(
      reportId: parseReportInt(json['reportId']),
      reviewId: parseReportInt(json['reviewId']),
      reviewCreatedAt: parseReportDateTime(json['reviewCreatedAt']),
      reviewerMemberId: parseReportInt(json['reviewerMemberId']),
      reviewerName: parseReportString(json['reviewerName']),
      reviewerGrade: parseReportInt(json['reviewerGrade']),
      reviewerDepartment: parseReportString(json['reviewerDepartment']),
      reviewerProfileImageUrl:
        (json['reviewerProfileImageUrl'] ??
            json['reviewerProfileUrl'] ??
            json['profileImageUrl'] ??
        json['profileUrl']) as String? ?? '',
      reviewContent: parseReportString(json['reviewContent']),
      reportContent: parseReportString(json['reportContent']),
      reportCreatedAt: parseReportDateTime(json['reportCreatedAt']),
      reportStatus: parseReportStatus(json['reportStatus']),
      deletedAt: parseReportDateTime(json['deletedAt']),
      deletedBy: parseNullableReportString(json['deletedBy']),
    );
  }

  final int reportId;
  final int reviewId;
  final DateTime? reviewCreatedAt;
  final int reviewerMemberId;
  final String reviewerName;
  final int reviewerGrade;
  final String reviewerDepartment;
  final String reviewerProfileImageUrl;
  final String reviewContent;
  final String reportContent;
  final DateTime? reportCreatedAt;
  final ReportStatus reportStatus;
  final DateTime? deletedAt;
  final String? deletedBy;

  ReportDetailEntity toEntity() {
    return ReportDetailEntity(
      reportId: reportId,
      reviewId: reviewId,
      reviewCreatedAt: reviewCreatedAt,
      reviewerMemberId: reviewerMemberId,
      reviewerName: reviewerName,
      reviewerGrade: reviewerGrade,
      reviewerDepartment: reviewerDepartment,
      reviewerProfileImageUrl: reviewerProfileImageUrl,
      reviewContent: reviewContent,
      reportContent: reportContent,
      reportCreatedAt: reportCreatedAt,
      reportStatus: reportStatus,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
    );
  }
}
