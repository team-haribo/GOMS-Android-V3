import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/report/data/response/report_parsers.dart';
import 'package:goms/features/report/presentation/models/report_resolve_result_model.dart';

part 'report_resolve_response.g.dart';

@JsonSerializable(createToJson: false)
class ReportResolveResponse {
  const ReportResolveResponse({
    required this.reportId,
    required this.reviewId,
    required this.reportStatus,
    required this.resolvedBy,
    this.resolvedAt,
  });

  factory ReportResolveResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportResolveResponseFromJson(json);

  @JsonKey(name: 'report_id', fromJson: parseReportInt)
  final int reportId;
  @JsonKey(name: 'review_id', fromJson: parseReportInt)
  final int reviewId;
  @JsonKey(name: 'report_status', fromJson: parseReportStatus)
  final ReportStatus reportStatus;
  @JsonKey(name: 'resolved_at', fromJson: parseReportDateTime)
  final DateTime? resolvedAt;
  @JsonKey(name: 'resolved_by', fromJson: parseReportInt)
  final int resolvedBy;

  ReportResolveResultModel toModel() {
    return ReportResolveResultModel(
      reportId: reportId,
      reviewId: reviewId,
      reportStatus: reportStatus,
      resolvedAt: resolvedAt,
      resolvedBy: resolvedBy,
    );
  }
}
