import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/report/data/response/report_parsers.dart';
import 'package:goms/features/report/domain/entities/report_detail_entity.dart';

part 'report_detail_response.g.dart';

@JsonSerializable(createToJson: false)
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

  factory ReportDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportDetailResponseFromJson(json);

  @JsonKey(fromJson: parseReportInt)
  final int reportId;
  @JsonKey(fromJson: parseReportInt)
  final int reviewId;
  @JsonKey(fromJson: parseReportDateTime)
  final DateTime? reviewCreatedAt;
  @JsonKey(fromJson: parseReportInt)
  final int reviewerMemberId;
  @JsonKey(fromJson: parseReportString)
  final String reviewerName;
  @JsonKey(fromJson: parseReportInt)
  final int reviewerGrade;
  @JsonKey(fromJson: parseReportString)
  final String reviewerDepartment;
  @JsonKey(readValue: _readReviewerProfileImageUrl, fromJson: parseReportString)
  final String reviewerProfileImageUrl;
  @JsonKey(fromJson: parseReportString)
  final String reviewContent;
  @JsonKey(fromJson: parseReportString)
  final String reportContent;
  @JsonKey(fromJson: parseReportDateTime)
  final DateTime? reportCreatedAt;
  @JsonKey(fromJson: parseReportStatus)
  final ReportStatus reportStatus;
  @JsonKey(fromJson: parseReportDateTime)
  final DateTime? deletedAt;
  @JsonKey(fromJson: parseNullableReportString)
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

Object? _readReviewerProfileImageUrl(Map<dynamic, dynamic> json, String key) =>
    json[key] ??
    json['reviewerProfileUrl'] ??
    json['profileImageUrl'] ??
    json['profileUrl'];
