import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/bottom_sheets/filter_button.dart';
import 'package:goms/core/widgets/buttons/qr_button.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/domain/entities/report_summary_entity.dart';
import 'package:goms/features/report/presentation/providers/admin_report_providers.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';
import 'package:goms/core/widgets/chips/category_chip.dart';
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
      floatingActionButton: const QRButton(type: RoleEnum.admin),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ReportTile(
            title: '신고 목록',
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
          Row(
            children: [
              Text(
                '검색 결과',
                style: AppTextStyles.title3.copyWith(
                  color: context.mainTextColor,
                ),
              ),
              const Spacer(),
              FilterButton(
                textColor: AppColors.admin,
                bottomSheetBuilder: (_) => ReportFilterBottomSheet(
                  initialSelection: ReportFilterSelection(
                    reportStatus: reportStatusFilter,
                  ),
                  onApply: (selection) => ref
                      .read(_reportStatusFilterProvider(_providerKey).notifier)
                      .setStatus(selection.reportStatus),
                  onReset: () => ref
                      .read(_reportStatusFilterProvider(_providerKey).notifier)
                      .setStatus(null),
                ),
              ),
            ],
          ),
          AppGap.v16,
          Expanded(
            child: RefreshIndicator(
              color: AppColors.admin,
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

  final AsyncValue<List<ReportSummaryEntity>> pendingReportsAsync;
  final AsyncValue<List<ReportSummaryEntity>> resolvedReportsAsync;
  final String query;
  final ReportStatus? reportStatusFilter;

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

    final reports = <ReportSummaryEntity>[...pendingReports, ...resolvedReports]
      ..sort((a, b) {
        final aTime =
            a.reportCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime =
            b.reportCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    final normalizedQuery = query.trim().toLowerCase();
    final List<ReportSummaryEntity> filteredReports = reports.where((report) {
      final matchesStatus = matchesReportStatusFilter(
        filter: reportStatusFilter,
        status: report.reportStatus,
      );

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

bool matchesReportStatusFilter({
  required ReportStatus? filter,
  required ReportStatus status,
}) {
  if (filter == null) {
    return true;
  }

  if (filter == ReportStatus.approved) {
    return status == ReportStatus.approved || status == ReportStatus.rejected;
  }

  return status == filter;
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.title1.copyWith(
            color: context.mainTextColor,
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

String _reportHeadline(ReportSummaryEntity report) {
  final reportContent = report.reportContent?.trim();
  if (reportContent != null && reportContent.isNotEmpty) {
    return reportContent;
  }
  return '신고 내용 없음';
}

String _reportPlaceName(ReportSummaryEntity report) {
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

// ---------------------------------------------------------------------------
// ReportFilterBottomSheet (moved from widgets/report_filter_bottom_sheet.dart)
// ---------------------------------------------------------------------------

class ReportFilterSelection {
  const ReportFilterSelection({
    this.reportStatus,
  });

  final ReportStatus? reportStatus;

  ReportFilterSelection copyWith({
    ReportStatus? reportStatus,
    bool clearReportStatus = false,
  }) {
    return ReportFilterSelection(
      reportStatus:
          clearReportStatus ? null : (reportStatus ?? this.reportStatus),
    );
  }
}

final _reportFilterSelectionProvider = NotifierProvider.autoDispose.family<
    _ReportFilterSelectionNotifier,
    ReportFilterSelection,
    (Object, ReportFilterSelection)>(_ReportFilterSelectionNotifier.new);

class _ReportFilterSelectionNotifier extends Notifier<ReportFilterSelection> {
  _ReportFilterSelectionNotifier(this.args);

  final (Object, ReportFilterSelection) args;

  @override
  ReportFilterSelection build() => args.$2;

  void setSelection(ReportFilterSelection selection) => state = selection;
}

class ReportFilterBottomSheet extends ConsumerStatefulWidget {
  const ReportFilterBottomSheet({
    super.key,
    this.initialSelection = const ReportFilterSelection(),
    this.onApply,
    this.onReset,
  });

  final ReportFilterSelection initialSelection;
  final ValueChanged<ReportFilterSelection>? onApply;
  final VoidCallback? onReset;

  @override
  ConsumerState<ReportFilterBottomSheet> createState() =>
      _ReportFilterBottomSheetState();
}

class _ReportFilterBottomSheetState
    extends ConsumerState<ReportFilterBottomSheet> {
  late final Object _providerIdentity;

  (Object, ReportFilterSelection) get _providerKey =>
      (_providerIdentity, widget.initialSelection);

  @override
  void initState() {
    super.initState();
    _providerIdentity = Object();
  }

  @override
  Widget build(BuildContext context) {
    final selection = ref.watch(_reportFilterSelectionProvider(_providerKey));

    return CommonBottomSheet(
      title: '필터',
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상태',
            style: AppTextStyles.title3.copyWith(
              color: context.isLightMode ? Colors.black : Colors.white,
            ),
          ),
          AppGap.v12,
          Row(
            children: [
              Expanded(
                child: CategoryChip(
                  category: '처리전',
                  selected: selection.reportStatus == ReportStatus.pending,
                  textColor: context.mainTextColor,
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      reportStatus: selected ? ReportStatus.pending : null,
                      clearReportStatus: !selected,
                    ),
                  ),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '처리완료',
                  selected: selection.reportStatus == ReportStatus.approved,
                  textColor: context.mainTextColor,
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      reportStatus: selected ? ReportStatus.approved : null,
                      clearReportStatus: !selected,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppGap.v24,
          GestureDetector(
            onTap: _handleReset,
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.negative.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '필터 초기화',
                style: AppTextStyles.text2.copyWith(
                  color: AppColors.negative,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReset() {
    ref
        .read(_reportFilterSelectionProvider(_providerKey).notifier)
        .setSelection(const ReportFilterSelection());
    widget.onReset?.call();
    Navigator.pop(context);
  }

  void _updateSelection(ReportFilterSelection selection) {
    ref
        .read(_reportFilterSelectionProvider(_providerKey).notifier)
        .setSelection(selection);
    _notifySelectionChanged(selection);
  }

  void _notifySelectionChanged(ReportFilterSelection selection) {
    widget.onApply?.call(selection);
  }
}
