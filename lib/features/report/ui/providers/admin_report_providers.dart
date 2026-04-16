import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/providers/report_data_providers.dart';
import 'package:goms/features/report/ui/models/report_detail_model.dart';
import 'package:goms/features/report/ui/models/report_summary_model.dart';

final pendingReportsProvider =
    AsyncNotifierProvider<PendingReportsNotifier, List<ReportSummaryModel>>(
  PendingReportsNotifier.new,
);

final resolvedReportsProvider =
    AsyncNotifierProvider<ResolvedReportsNotifier, List<ReportSummaryModel>>(
  ResolvedReportsNotifier.new,
);

final reportDetailProvider =
    FutureProvider.family<ReportDetailModel, int>((ref, reportId) async {
  try {
    return await ref.read(reportRepositoryProvider).getReportDetail(reportId);
  } on DioException catch (error) {
    throw ReportAdminException(
      NetworkException.fromDioException(error).message,
    );
  } catch (_) {
    throw const ReportAdminException('신고 상세를 불러오지 못했습니다.');
  }
});

class PendingReportsNotifier extends AsyncNotifier<List<ReportSummaryModel>> {
  @override
  Future<List<ReportSummaryModel>> build() async {
    return _fetch();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<ReportDetailModel> resolve({
    required int reportId,
    required ReportStatus reportStatus,
  }) async {
    try {
      await ref.read(reportRepositoryProvider).resolveReport(
            reportId: reportId,
            reportStatus: reportStatus,
          );
      await reload();
      ref.invalidate(resolvedReportsProvider);
      ref.invalidate(reportDetailProvider(reportId));
      return await ref.read(reportRepositoryProvider).getReportDetail(reportId);
    } on DioException catch (error) {
      throw ReportAdminException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const ReportAdminException('신고 처리 중 문제가 발생했습니다.');
    }
  }

  Future<List<ReportSummaryModel>> _fetch() async {
    try {
      return await ref.read(reportRepositoryProvider).getPendingReports();
    } on DioException catch (error) {
      throw ReportAdminException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const ReportAdminException('대기 중 신고 목록을 불러오지 못했습니다.');
    }
  }
}

class ResolvedReportsNotifier extends AsyncNotifier<List<ReportSummaryModel>> {
  @override
  Future<List<ReportSummaryModel>> build() async {
    return _fetch();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<ReportSummaryModel>> _fetch() async {
    try {
      return await ref.read(reportRepositoryProvider).getResolvedReports();
    } on DioException catch (error) {
      throw ReportAdminException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const ReportAdminException('처리된 신고 목록을 불러오지 못했습니다.');
    }
  }
}

class ReportAdminException implements Exception {
  const ReportAdminException(this.message);

  final String message;
}
