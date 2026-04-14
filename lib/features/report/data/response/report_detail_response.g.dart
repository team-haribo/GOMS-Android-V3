// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDetailResponse _$ReportDetailResponseFromJson(
        Map<String, dynamic> json) =>
    ReportDetailResponse(
      reportId: parseReportInt(json['reportId']),
      reviewId: parseReportInt(json['reviewId']),
      reviewCreatedAt: parseReportDateTime(json['reviewCreatedAt']),
      reviewerMemberId: parseReportInt(json['reviewerMemberId']),
      reviewerName: parseReportString(json['reviewerName']),
      reviewerGrade: parseReportInt(json['reviewerGrade']),
      reviewerDepartment: parseReportString(json['reviewerDepartment']),
      reviewerProfileImageUrl: parseReportString(
          _readReviewerProfileImageUrl(json, 'reviewerProfileImageUrl')),
      reviewContent: parseReportString(json['reviewContent']),
      reportContent: parseReportString(json['reportContent']),
      reportCreatedAt: parseReportDateTime(json['reportCreatedAt']),
      reportStatus: parseReportStatus(json['reportStatus']),
      deletedAt: parseReportDateTime(json['deletedAt']),
      deletedBy: parseNullableReportString(json['deletedBy']),
    );
