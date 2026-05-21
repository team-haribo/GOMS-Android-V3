import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/providers/report_data_providers.dart';
import 'package:goms/features/report/domain/entities/report_detail_entity.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';

final pendingReportsProvider =
    AsyncNotifierProvider<PendingReportsNotifier, List<ReportSummaryEntity>>(
  PendingReportsNotifier.new,
);

final resolvedReportsProvider =
    AsyncNotifierProvider<ResolvedReportsNotifier, List<ReportSummaryEntity>>(
  ResolvedReportsNotifier.new,
);

final reportDetailProvider =
    FutureProvider.family<ReportDetailEntity, int>((ref, reportId) async {
  try {
    return await ref.watch(reportRemoteDataSourceProvider).getReportDetail(reportId);
  } on DioException catch (error) {
    throw ReportAdminException(
      NetworkException.fromDioException(error).message,
    );
  } catch (_) {
    throw const ReportAdminException('신고 상세를 불러오지 못했습니다.');
  }
});

class PendingReportsNotifier extends AsyncNotifier<List<ReportSummaryEntity>> {
  @override
  Future<List<ReportSummaryEntity>> build() async {
    return _fetch();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<ReportDetailEntity> resolve({
    required int reportId,
    required ReportStatus reportStatus,
  }) async {
    try {
      await ref.read(reportRemoteDataSourceProvider).resolveReport(
            reportId: reportId,
            reportStatus: reportStatus,
          );
      await reload();
      ref.invalidate(resolvedReportsProvider);
      ref.invalidate(reportDetailProvider(reportId));
      return await ref.read(reportRemoteDataSourceProvider).getReportDetail(reportId);
    } on DioException catch (error) {
      throw ReportAdminException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const ReportAdminException('신고 처리 중 문제가 발생했습니다.');
    }
  }

  Future<List<ReportSummaryEntity>> _fetch() async {
    try {
      return await ref.watch(reportRemoteDataSourceProvider).getPendingReports();
    } on DioException catch (error) {
      throw ReportAdminException(
        NetworkException.fromDioException(error).message,
      );
    } catch (_) {
      throw const ReportAdminException('대기 중 신고 목록을 불러오지 못했습니다.');
    }
  }
}

class ResolvedReportsNotifier extends AsyncNotifier<List<ReportSummaryEntity>> {
  @override
  Future<List<ReportSummaryEntity>> build() async {
    return _fetch();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<ReportSummaryEntity>> _fetch() async {
    try {
      return await ref.watch(reportRemoteDataSourceProvider).getResolvedReports();
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
