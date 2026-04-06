import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/text_fields/search_student.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/data/mock/report_mock_data.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';
import 'package:goms/features/report/presentation/providers/admin_report_providers.dart';
import 'package:intl/intl.dart';

class AdminReportListScreen extends ConsumerStatefulWidget {
  const AdminReportListScreen({super.key});

  @override
  ConsumerState<AdminReportListScreen> createState() =>
      _AdminReportListScreenState();
}

class _AdminReportListScreenState extends ConsumerState<AdminReportListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(pendingReportsProvider);
      ref.invalidate(resolvedReportsProvider);
      unawaited(ref.read(pendingReportsProvider.future));
      unawaited(ref.read(resolvedReportsProvider.future));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingReportsAsync = ref.watch(pendingReportsProvider);
    final resolvedReportsAsync = ref.watch(resolvedReportsProvider);

    return BaseScaffold(
      showAppBar: true,
      role: RoleEnum.admin,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ReportTile(),
          AppGap.v24,
          SearchStudentField(
            controller: _searchController,
            hintText: '학생 검색',
            onChanged: (value) => setState(() => _query = value),
          ),
          AppGap.v16,
          Text(
            '검색 결과',
            style: AppTextStyles.title3.copyWith(
              color: context.mainTextColor,
            ),
          ),
          AppGap.v24,
          Expanded(
            child: _ReportListBody(
              pendingReportsAsync: pendingReportsAsync,
              resolvedReportsAsync: resolvedReportsAsync,
              query: _query,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportListBody extends ConsumerWidget {
  const _ReportListBody({
    required this.pendingReportsAsync,
    required this.resolvedReportsAsync,
    required this.query,
  });

  final AsyncValue<List<ReportSummaryEntity>> pendingReportsAsync;
  final AsyncValue<List<ReportSummaryEntity>> resolvedReportsAsync;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReports =
        pendingReportsAsync.asData?.value ?? const <ReportSummaryEntity>[];
    final resolvedReports =
        resolvedReportsAsync.asData?.value ?? const <ReportSummaryEntity>[];

    final hasAnyData =
        pendingReportsAsync.hasValue || resolvedReportsAsync.hasValue;
    final isLoading = !hasAnyData &&
        (pendingReportsAsync.isLoading || resolvedReportsAsync.isLoading);
    final error = pendingReportsAsync.hasError && resolvedReportsAsync.hasError
        ? (pendingReportsAsync.error ?? resolvedReportsAsync.error)
        : null;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _ReportErrorView(
        message: error is ReportAdminException
            ? error.message
            : '신고 목록을 불러오지 못했어요.',
        onRetry: () {
          ref.read(pendingReportsProvider.notifier).reload();
          ref.read(resolvedReportsProvider.notifier).reload();
        },
      );
    }

    final reports = <ReportSummaryEntity>[...pendingReports, ...resolvedReports]
      ..sort((a, b) {
        final aTime =
            a.reportCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime =
            b.reportCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    final normalizedQuery = query.trim().toLowerCase();
    final List<ReportSummaryEntity> filteredReports = normalizedQuery.isEmpty
        ? reports
        : reports.where((report) {
            final searchable = [
              report.reviewerName,
              report.reviewerDepartment,
              report.reportId.toString(),
              report.reviewId.toString(),
              _mockHeadline(report),
            ].join(' ').toLowerCase();
            return searchable.contains(normalizedQuery);
          }).toList(growable: false);

    if (filteredReports.isEmpty) {
      return Center(
        child: Text(
          normalizedQuery.isEmpty ? '신고 내역이 없어요.' : '검색 결과가 없어요.',
          style: AppTextStyles.text2.copyWith(color: context.sub2Color),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredReports.length,
      separatorBuilder: (_, __) => Divider(
        color: context.buttonColor,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final report = filteredReports[index];
        return _ReportListTile(
          report: report,
          onTap: () => context.push(
            RoutePath.studentCouncilReportDetail,
            extra: report.reportId,
          ),
        );
      },
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
            '신고 목록',
            style: AppTextStyles.title1.copyWith(
              color: context.mainTextColor,
            ),
          ),
        const Spacer(),
        TextButton(
          onPressed: () {} ,// 필터 바텀싯 로직 추가 예정
          child: Text(
            '필터',
            style: AppTextStyles.caption2.copyWith(
              color: AppColors.admin,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportListTile extends StatelessWidget {
  const _ReportListTile({
    required this.report,
    required this.onTap,
  });

  final ReportSummaryEntity report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yy.MM.dd HH:mm:ss');
    final createdAt = report.reportCreatedAt == null
        ? '-'
        : formatter.format(report.reportCreatedAt!.toLocal());
    final headline = _mockHeadline(report);
    final placeName = _mockPlaceName(report);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text2.copyWith(
                      color: context.sub1Color,
                    ),
                  ),
                  AppGap.v4,
                  Text(
                    placeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption1.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                  AppGap.v4,
                  Text(
                    createdAt,
                    style: AppTextStyles.caption1.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                ],
              ),
            ),
            AppGap.h12,
            _StatusChip(status: report.reportStatus),
          ],
        ),
      ),
    );
  }
}

String _mockHeadline(ReportSummaryEntity report) {
  final mockDetail = debugFindReportMockDetail(report.reportId);
  if (mockDetail != null && mockDetail.reportContent.trim().isNotEmpty) {
    return mockDetail.reportContent;
  }

  return '후기 신고 #${report.reportId}';
}

String _mockPlaceName(ReportSummaryEntity report) {
  final placeName = switch (report.reportId) {
    9001 => '분식마을',
    9002 => '떡볶이 연구소',
    9003 => '야간스터디카페',
    9101 => '브런치하우스',
    9102 => '수제버거랩',
    _ => '',
  };

  if (placeName.isNotEmpty) return placeName;

  return '장소 정보 없음';
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ReportStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReportStatus.pending => ('처리전', AppColors.admin),
      ReportStatus.approved => ('처리 완료', context.sub2Color),
      ReportStatus.rejected => ('기각', context.sub2Color),
    };

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        label,
        style: AppTextStyles.caption1.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ReportErrorView extends StatelessWidget {
  const _ReportErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: AppTextStyles.text2.copyWith(color: context.sub2Color),
            textAlign: TextAlign.center,
          ),
          AppGap.v12,
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
