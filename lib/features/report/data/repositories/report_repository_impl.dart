import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/datasources/report_remote_datasource.dart';
import 'package:goms/features/report/data/request/report_resolve_request.dart';
import 'package:goms/features/report/data/repositories/report_repository.dart';
import 'package:goms/features/report/ui/models/report_detail_model.dart';
import 'package:goms/features/report/ui/models/report_resolve_result_model.dart';
import 'package:goms/features/report/ui/models/report_summary_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._remoteDataSource);

  final ReportRemoteDataSource _remoteDataSource;

  @override
  Future<List<ReportSummaryModel>> getPendingReports() async {
    final response = await _remoteDataSource.getPendingReports();
    return response.toModel();
  }

  @override
  Future<List<ReportSummaryModel>> getResolvedReports() async {
    final response = await _remoteDataSource.getResolvedReports();
    return response.toModel();
  }

  @override
  Future<ReportDetailModel> getReportDetail(int reportId) async {
    final response = await _remoteDataSource.getReportDetail(reportId);
    return response.toModel();
  }

  @override
  Future<ReportResolveResultModel> resolveReport({
    required int reportId,
    required ReportStatus reportStatus,
  }) async {
    final response = await _remoteDataSource.resolveReport(
      reportId: reportId,
      request: ReportResolveRequest(reportStatus: reportStatus),
    );
    return response.toModel();
  }
}
