import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/ui/models/report_detail_model.dart';
import 'package:goms/features/report/ui/models/report_resolve_result_model.dart';
import 'package:goms/features/report/ui/models/report_summary_model.dart';

abstract class ReportRepository {
  Future<void> createReviewReport({
    required int reviewId,
    required String reason,
  });

  Future<List<ReportSummaryModel>> getPendingReports();

  Future<List<ReportSummaryModel>> getResolvedReports();

  Future<ReportDetailModel> getReportDetail(int reportId);

  Future<ReportResolveResultModel> resolveReport({
    required int reportId,
    required ReportStatus reportStatus,
  });
}
