import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/report/data/response/report_response.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';

part 'report_list_response.g.dart';

@JsonSerializable(createToJson: false)
class ReportListResponse {
  const ReportListResponse({
    required this.reports,
  });

  factory ReportListResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportListResponseFromJson(json);

  @JsonKey(defaultValue: <ReportResponse>[], fromJson: _reportsFromJson)
  final List<ReportResponse> reports;

  List<ReportSummaryEntity> toEntity() {
    return reports.map((report) => report.toEntity()).toList();
  }
}

List<ReportResponse> _reportsFromJson(List<dynamic>? values) =>
    (values ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(ReportResponse.fromJson)
        .toList(growable: false);
