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
import 'package:goms/features/map/review/domain/enums/report_status.dart';
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
  bool _showPending = true;

  @override
  Widget build(BuildContext context) {
    final reportsAsync = _showPending
        ? ref.watch(pendingReportsProvider)
        : ref.watch(resolvedReportsProvider);

    return BaseScaffold(
      showAppBar: true,
      role: RoleEnum.admin,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '신고 관리',
            style: AppTextStyles.title1.copyWith(
              color: context.mainTextColor,
            ),
          ),
          AppGap.v24,
          _ReportTabBar(
            showPending: _showPending,
            onChanged: (value) => setState(() => _showPending = value),
          ),
          AppGap.v16,
          Expanded(
            child: reportsAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return Center(
                    child: Text(
                      _showPending ? '대기 중인 신고가 없어요.' : '처리된 신고가 없어요.',
                      style: AppTextStyles.text2.copyWith(
                        color: context.sub2Color,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: reports.length,
                  separatorBuilder: (_, __) => Divider(
                    color: context.buttonColor,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return _ReportListTile(
                      report: report,
                      onTap: () => context.push(
                        RoutePath.studentCouncilReportDetail,
                        extra: report.reportId,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ReportErrorView(
                message: error is ReportAdminException
                    ? error.message
                    : '신고 목록을 불러오지 못했어요.',
                onRetry: () {
                  if (_showPending) {
                    ref.read(pendingReportsProvider.notifier).reload();
                    return;
                  }
                  ref.read(resolvedReportsProvider.notifier).reload();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTabBar extends StatelessWidget {
  const _ReportTabBar({
    required this.showPending,
    required this.onChanged,
  });

  final bool showPending;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: '대기 중',
              selected: showPending,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: '처리 완료',
              selected: !showPending,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected ? AppColors.admin : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.text2.copyWith(
            color: selected ? Colors.white : context.sub2Color,
          ),
        ),
      ),
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
    final formatter = DateFormat('yy.MM.dd HH:mm');
    final createdAt = report.reportCreatedAt == null
        ? '-'
        : formatter.format(report.reportCreatedAt!.toLocal());

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          report.reviewerName,
                          style: AppTextStyles.text1.copyWith(
                            color: context.mainTextColor,
                          ),
                        ),
                      ),
                      _StatusChip(status: report.reportStatus),
                    ],
                  ),
                  AppGap.v4,
                  Text(
                    '${report.reviewerGrade}학년 | ${report.reviewerDepartment}',
                    style: AppTextStyles.caption1.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                  AppGap.v4,
                  Text(
                    '리뷰 #${report.reviewId} · 신고 #${report.reportId} · $createdAt',
                    style: AppTextStyles.caption2.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ReportStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReportStatus.pending => ('대기', Colors.orange),
      ReportStatus.approved => ('승인', AppColors.admin),
      ReportStatus.rejected => ('반려', AppColors.negative),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption2.copyWith(color: color),
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
