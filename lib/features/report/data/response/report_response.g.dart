// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportResponse _$ReportResponseFromJson(Map<String, dynamic> json) =>
    ReportResponse(
      reportId: parseReportInt(json['reportId']),
      reviewId: parseReportInt(json['reviewId']),
      reviewerMemberId: parseReportInt(json['reviewerMemberId']),
      reviewerName: parseReportString(json['reviewerName']),
      reviewerGrade: parseReportInt(json['reviewerGrade']),
      reviewerDepartment: parseReportString(json['reviewerDepartment']),
      reviewerProfileImageUrl: parseReportString(
          _readReviewerProfileImageUrl(json, 'reviewerProfileImageUrl')),
      reportCreatedAt: parseReportDateTime(json['reportCreatedAt']),
      reportStatus: parseReportStatus(json['reportStatus']),
      deletedAt: parseReportDateTime(json['deletedAt']),
      deletedBy: parseNullableReportString(json['deletedBy']),
    );
