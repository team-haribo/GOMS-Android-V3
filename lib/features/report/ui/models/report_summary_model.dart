import 'package:flutter/foundation.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';

@immutable
class ReportSummaryModel {
  const ReportSummaryModel({
    required this.reportId,
    required this.reviewId,
    required this.reviewerMemberId,
    required this.reviewerName,
    required this.reviewerGrade,
    required this.reviewerDepartment,
    this.placeName,
    this.placeAddress,
    this.reviewerProfileImageUrl = '',
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
  final String? placeName;
  final String? placeAddress;
  final String reviewerProfileImageUrl;
  final DateTime? reportCreatedAt;
  final ReportStatus reportStatus;
  final DateTime? deletedAt;
  final String? deletedBy;
}
