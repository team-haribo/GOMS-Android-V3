import 'package:dio/dio.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/request/create_review_report_request.dart';
import 'package:goms/features/report/data/request/report_resolve_request.dart';
import 'package:goms/features/report/data/response/report_detail_response.dart';
import 'package:goms/features/report/data/response/report_list_response.dart';
import 'package:goms/features/report/data/response/report_resolve_response.dart';
import 'package:goms/features/report/domain/entities/report_detail_entity.dart';
import 'package:goms/features/report/domain/entities/report_resolve_result_entity.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';

class ReportRemoteDataSource {
  const ReportRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ReportSummaryEntity>> getPendingReports() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/student-council/report/pending',
    );
    return ReportListResponse.fromJson(response.data ?? const {}).toEntity();
  }

  Future<List<ReportSummaryEntity>> getResolvedReports() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/student-council/report/resolved',
    );
    return ReportListResponse.fromJson(response.data ?? const {}).toEntity();
  }

  Future<ReportDetailEntity> getReportDetail(int reportId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/report/$reportId',
    );
    return ReportDetailResponse.fromJson(response.data ?? const {}).toEntity();
  }

  Future<void> createReviewReport({
    required int reviewId,
    required String reason,
  }) async {
    await _dio.post<void>(
      '/api/v3/report/$reviewId',
      data: CreateReviewReportRequest(reason: reason).toJson(),
    );
  }

  Future<ReportResolveResultEntity> resolveReport({
    required int reportId,
    required ReportStatus reportStatus,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v3/student-council/report/$reportId',
      data: ReportResolveRequest(reportStatus: reportStatus).toJson(),
    );
    return ReportResolveResponse.fromJson(response.data ?? const {}).toEntity();
  }
}
