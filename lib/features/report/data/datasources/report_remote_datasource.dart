import 'package:dio/dio.dart';
import 'package:goms/features/report/data/request/report_resolve_request.dart';
import 'package:goms/features/report/data/response/report_detail_response.dart';
import 'package:goms/features/report/data/response/report_list_response.dart';
import 'package:goms/features/report/data/response/report_resolve_response.dart';

class ReportRemoteDataSource {
  const ReportRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ReportListResponse> getPendingReports() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/student-council/report/pending',
    );
    return ReportListResponse.fromJson(response.data ?? const {});
  }

  Future<ReportListResponse> getResolvedReports() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/student-council/report/resolved',
    );
    return ReportListResponse.fromJson(response.data ?? const {});
  }

  Future<ReportDetailResponse> getReportDetail(int reportId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v3/report/$reportId',
    );
    return ReportDetailResponse.fromJson(response.data ?? const {});
  }

  Future<ReportResolveResponse> resolveReport({
    required int reportId,
    required ReportResolveRequest request,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v3/student-council/report/$reportId',
      data: request.toJson(),
    );
    return ReportResolveResponse.fromJson(response.data ?? const {});
  }
}
