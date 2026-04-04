import 'package:goms/features/report/data/response/report_response.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';

class ReportListResponse {
  const ReportListResponse({
    required this.reports,
  });

  factory ReportListResponse.fromJson(Map<String, dynamic> json) {
    final reports = (json['reports'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ReportResponse.fromJson)
        .toList();

    return ReportListResponse(reports: reports);
  }

  final List<ReportResponse> reports;

  List<ReportSummaryEntity> toEntity() {
    return reports.map((report) => report.toEntity()).toList();
  }
}
