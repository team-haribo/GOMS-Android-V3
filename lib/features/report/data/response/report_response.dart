import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/report/data/response/report_parsers.dart';
import 'package:goms/features/report/presentation/models/report_summary_model.dart';

part 'report_response.g.dart';

@JsonSerializable(createToJson: false)
class ReportResponse {
  const ReportResponse({
    required this.reportId,
    required this.reviewId,
    required this.reviewerMemberId,
    required this.reviewerName,
    required this.reviewerGrade,
    required this.reviewerDepartment,
    required this.reportContent,
    required this.placeName,
    required this.placeAddress,
    required this.reviewerProfileImageUrl,
    required this.reportCreatedAt,
    required this.reportStatus,
    this.deletedAt,
    this.deletedBy,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportResponseFromJson(json);

  @JsonKey(fromJson: parseReportInt)
  final int reportId;
  @JsonKey(fromJson: parseReportInt)
  final int reviewId;
  @JsonKey(fromJson: parseReportInt)
  final int reviewerMemberId;
  @JsonKey(fromJson: parseReportString)
  final String reviewerName;
  @JsonKey(fromJson: parseReportInt)
  final int reviewerGrade;
  @JsonKey(fromJson: parseReportString)
  final String reviewerDepartment;
  @JsonKey(readValue: _readReportContent, fromJson: parseNullableReportString)
  final String? reportContent;
  @JsonKey(readValue: _readPlaceName, fromJson: parseNullableReportString)
  final String? placeName;
  @JsonKey(readValue: _readPlaceAddress, fromJson: parseNullableReportString)
  final String? placeAddress;
  @JsonKey(readValue: _readReviewerProfileImageUrl, fromJson: parseReportString)
  final String reviewerProfileImageUrl;
  @JsonKey(fromJson: parseReportDateTime)
  final DateTime? reportCreatedAt;
  @JsonKey(fromJson: parseReportStatus)
  final ReportStatus reportStatus;
  @JsonKey(fromJson: parseReportDateTime)
  final DateTime? deletedAt;
  @JsonKey(fromJson: parseNullableReportString)
  final String? deletedBy;

  ReportSummaryModel toModel() {
    return ReportSummaryModel(
      reportId: reportId,
      reviewId: reviewId,
      reviewerMemberId: reviewerMemberId,
      reviewerName: reviewerName,
      reviewerGrade: reviewerGrade,
      reviewerDepartment: reviewerDepartment,
      reportContent: reportContent,
      placeName: placeName,
      placeAddress: placeAddress,
      reviewerProfileImageUrl: reviewerProfileImageUrl,
      reportCreatedAt: reportCreatedAt,
      reportStatus: reportStatus,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
    );
  }
}

Object? _readReportContent(Map<dynamic, dynamic> json, String key) =>
    json[key] ??
    json['content'] ??
    json['reportReason'] ??
    _readNestedReportField(json, 'content') ??
    _readNestedReportField(json, 'reportContent');

Object? _readReviewerProfileImageUrl(Map<dynamic, dynamic> json, String key) =>
    json[key] ??
    json['reviewerProfileUrl'] ??
    json['profileImageUrl'] ??
    json['profileUrl'];

Object? _readPlaceName(Map<dynamic, dynamic> json, String key) =>
    json[key] ??
    json['reviewPlaceName'] ??
    json['targetPlaceName'] ??
    _readNestedPlaceField(json, 'placeName');

Object? _readPlaceAddress(Map<dynamic, dynamic> json, String key) =>
    json[key] ??
    json['reviewPlaceAddress'] ??
    json['targetPlaceAddress'] ??
    _readNestedPlaceField(json, 'address');

Object? _readNestedPlaceField(Map<dynamic, dynamic> json, String key) {
  final place = json['place'];
  if (place is Map<dynamic, dynamic>) {
    return place[key];
  }
  return null;
}

Object? _readNestedReportField(Map<dynamic, dynamic> json, String key) {
  final report = json['report'];
  if (report is Map<dynamic, dynamic>) {
    return report[key];
  }
  return null;
}
