import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/datasources/report_remote_datasource.dart';
import 'package:goms/features/report/data/request/create_review_report_request.dart';
import 'package:goms/features/report/data/request/report_resolve_request.dart';
import 'package:goms/features/report/domain/entities/report_detail_entity.dart';
import 'package:goms/features/report/domain/entities/report_resolve_result_entity.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';
import 'package:goms/features/report/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._remoteDataSource);

  final ReportRemoteDataSource _remoteDataSource;

  @override
  Future<void> createReviewReport({
    required int reviewId,
    required String reason,
  }) {
    return _remoteDataSource.createReviewReport(
      reviewId: reviewId,
      request: CreateReviewReportRequest(reason: reason),
    );
  }

  @override
  Future<List<ReportSummaryEntity>> getPendingReports() async {
    final response = await _remoteDataSource.getPendingReports();
    return response.toEntity();
  }

  @override
  Future<List<ReportSummaryEntity>> getResolvedReports() async {
    final response = await _remoteDataSource.getResolvedReports();
    return response.toEntity();
  }

  @override
  Future<ReportDetailEntity> getReportDetail(int reportId) async {
    final response = await _remoteDataSource.getReportDetail(reportId);
    return response.toEntity();
  }

  @override
  Future<ReportResolveResultEntity> resolveReport({
    required int reportId,
    required ReportStatus reportStatus,
  }) async {
    final response = await _remoteDataSource.resolveReport(
      reportId: reportId,
      request: ReportResolveRequest(reportStatus: reportStatus),
    );
    return response.toEntity();
  }
}
