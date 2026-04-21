import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/bottom_sheets/filter_button.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/text_fields/search_student.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/ui/models/report_summary_model.dart';
import 'package:goms/features/report/ui/providers/admin_report_providers.dart';
import 'package:goms/features/report/ui/widgets/report_filter_bottom_sheet.dart';
import 'package:intl/intl.dart';

final _reportSearchQueryProvider = NotifierProvider.autoDispose
    .family<_ReportSearchQueryNotifier, String, Object>(
  _ReportSearchQueryNotifier.new,
);
final _reportStatusFilterProvider = NotifierProvider.autoDispose
    .family<_ReportStatusFilterNotifier, ReportStatus?, Object>(
  _ReportStatusFilterNotifier.new,
);

class _ReportSearchQueryNotifier extends Notifier<String> {
  _ReportSearchQueryNotifier(this.key);

  final Object key;

  @override
  String build() => '';

  void setQuery(String value) => state = value;
}

class _ReportStatusFilterNotifier extends Notifier<ReportStatus?> {
  _ReportStatusFilterNotifier(this.key);

  final Object key;

  @override
  ReportStatus? build() => null;

  void setStatus(ReportStatus? value) => state = value;
}

class AdminReportListScreen extends ConsumerStatefulWidget {
  const AdminReportListScreen({super.key});

  @override
  ConsumerState<AdminReportListScreen> createState() =>
      _AdminReportListScreenState();
}

class _AdminReportListScreenState extends ConsumerState<AdminReportListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final Object _providerKey;

  @override
  void initState() {
    super.initState();
    _providerKey = Object();
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
    final query = ref.watch(_reportSearchQueryProvider(_providerKey));
    final reportStatusFilter =
        ref.watch(_reportStatusFilterProvider(_providerKey));

    return BaseScaffold(
      showAppBar: true,
      role: RoleEnum.admin,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReportTile(
            reportStatusFilter: reportStatusFilter,
            onResetFilter: () => ref
                .read(_reportStatusFilterProvider(_providerKey).notifier)
                .setStatus(null),
            onApplyFilter: (selection) => ref
                .read(_reportStatusFilterProvider(_providerKey).notifier)
                .setStatus(selection.reportStatus),
          ),
          AppGap.v24,
          SearchStudentField(
            controller: _searchController,
            hintText: '학생 검색',
            onChanged: (value) => ref
                .read(_reportSearchQueryProvider(_providerKey).notifier)
                .setQuery(value),
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
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  ref.read(pendingReportsProvider.notifier).reload(),
                  ref.read(resolvedReportsProvider.notifier).reload(),
                ]);
              },
              child: _ReportListBody(
                pendingReportsAsync: pendingReportsAsync,
                resolvedReportsAsync: resolvedReportsAsync,
                query: query,
                reportStatusFilter: reportStatusFilter,
              ),
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
    required this.reportStatusFilter,
  });

  final AsyncValue<List<ReportSummaryModel>> pendingReportsAsync;
  final AsyncValue<List<ReportSummaryModel>> resolvedReportsAsync;
  final String query;
  final ReportStatus? reportStatusFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReports =
        pendingReportsAsync.asData?.value ?? const <ReportSummaryModel>[];
    final resolvedReports =
        resolvedReportsAsync.asData?.value ?? const <ReportSummaryModel>[];

    final hasAnyData =
        pendingReportsAsync.hasValue || resolvedReportsAsync.hasValue;
    final isLoading = !hasAnyData &&
        (pendingReportsAsync.isLoading || resolvedReportsAsync.isLoading);
    final error = pendingReportsAsync.hasError && resolvedReportsAsync.hasError
        ? (pendingReportsAsync.error ?? resolvedReportsAsync.error)
        : null;

    if (isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    if (error != null) {
      return _ReportErrorView(
        message:
            error is ReportAdminException ? error.message : '신고 목록을 불러오지 못했어요.',
        onRetry: () {
          ref.read(pendingReportsProvider.notifier).reload();
          ref.read(resolvedReportsProvider.notifier).reload();
        },
      );
    }

    final reports = <ReportSummaryModel>[...pendingReports, ...resolvedReports]
      ..sort((a, b) {
        final aTime =
            a.reportCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime =
            b.reportCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    final normalizedQuery = query.trim().toLowerCase();
    final List<ReportSummaryModel> filteredReports = reports.where((report) {
      final matchesStatus = reportStatusFilter == null ||
          report.reportStatus == reportStatusFilter;

      final matchesQuery = normalizedQuery.isEmpty ||
          [
            report.reviewerName,
            report.reviewerDepartment,
            report.reportId.toString(),
            report.reviewId.toString(),
            _reportHeadline(report),
            report.placeName ?? '',
            report.placeAddress ?? '',
          ].join(' ').toLowerCase().contains(normalizedQuery);

      return matchesStatus && matchesQuery;
    }).toList(growable: false);

    if (filteredReports.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 280,
            child: Center(
              child: Text(
                normalizedQuery.isEmpty ? '신고 내역이 없어요.' : '검색 결과가 없어요.',
                style: AppTextStyles.text2.copyWith(color: context.sub2Color),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
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
  const _ReportTile({
    required this.reportStatusFilter,
    required this.onApplyFilter,
    required this.onResetFilter,
  });

  final ReportStatus? reportStatusFilter;
  final ValueChanged<ReportFilterSelection> onApplyFilter;
  final VoidCallback onResetFilter;

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
        FilterButton(
          bottomSheetBuilder: (_) => ReportFilterBottomSheet(
            initialSelection: ReportFilterSelection(
              reportStatus: reportStatusFilter,
            ),
            onApply: onApplyFilter,
            onReset: onResetFilter,
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

  final ReportSummaryModel report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yy.MM.dd HH:mm:ss');
    final createdAt = report.reportCreatedAt == null
        ? '-'
        : formatter.format(report.reportCreatedAt!.toLocal());
    final headline = _reportHeadline(report);
    final placeName = _reportPlaceName(report);

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

String _reportHeadline(ReportSummaryModel report) {
  return '후기 신고 #${report.reportId}';
}

String _reportPlaceName(ReportSummaryModel report) {
  final placeName = report.placeName?.trim();
  final placeAddress = report.placeAddress?.trim();

  if (placeName != null && placeName.isNotEmpty) {
    if (placeAddress != null && placeAddress.isNotEmpty) {
      return '$placeName · $placeAddress';
    }
    return placeName;
  }

  if (placeAddress != null && placeAddress.isNotEmpty) {
    return placeAddress;
  }

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
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 280,
          child: Center(
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
          ),
        ),
      ],
    );
  }
}
