// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_resolve_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportResolveResponse _$ReportResolveResponseFromJson(
        Map<String, dynamic> json) =>
    ReportResolveResponse(
      reportId: parseReportInt(json['report_id']),
      reviewId: parseReportInt(json['review_id']),
      reportStatus: parseReportStatus(json['report_status']),
      resolvedBy: parseReportInt(json['resolved_by']),
      resolvedAt: parseReportDateTime(json['resolved_at']),
    );
