import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/domain/entities/report_detail_entity.dart';
import 'package:goms/features/report/domain/entities/report_resolve_result_entity.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';

abstract class ReportRepository {
  Future<void> createReviewReport({
    required int reviewId,
    required String reason,
  });

  Future<List<ReportSummaryEntity>> getPendingReports();

  Future<List<ReportSummaryEntity>> getResolvedReports();

  Future<ReportDetailEntity> getReportDetail(int reportId);

  Future<ReportResolveResultEntity> resolveReport({
    required int reportId,
    required ReportStatus reportStatus,
  });
}
