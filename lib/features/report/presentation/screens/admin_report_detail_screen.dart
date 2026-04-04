import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/domain/entities/report_detail_entity.dart';
import 'package:goms/features/report/presentation/providers/admin_report_providers.dart';
import 'package:intl/intl.dart';

class AdminReportDetailScreen extends ConsumerStatefulWidget {
  const AdminReportDetailScreen({
    super.key,
    required this.reportId,
  });

  final int reportId;

  @override
  ConsumerState<AdminReportDetailScreen> createState() =>
      _AdminReportDetailScreenState();
}

class _AdminReportDetailScreenState
    extends ConsumerState<AdminReportDetailScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(reportDetailProvider(widget.reportId));

    return BaseScaffold(
      showAppBar: true,
      role: RoleEnum.admin,
      body: detailAsync.when(
        data: (detail) => _buildContent(context, detail),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error is ReportAdminException
                    ? error.message
                    : '신고 상세를 불러오지 못했어요.',
                style: AppTextStyles.text2.copyWith(color: context.sub2Color),
                textAlign: TextAlign.center,
              ),
              AppGap.v12,
              TextButton(
                onPressed: () => ref.invalidate(
                  reportDetailProvider(widget.reportId),
                ),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReportDetailEntity detail) {
    final formatter = DateFormat('yyyy.MM.dd HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '신고 상세',
                style: AppTextStyles.title1.copyWith(
                  color: context.mainTextColor,
                ),
              ),
            ),
            _StatusChip(status: detail.reportStatus),
          ],
        ),
        AppGap.v24,
        _InfoCard(
          title: '신고 정보',
          rows: [
            _InfoRow(label: '신고 번호', value: '#${detail.reportId}'),
            _InfoRow(label: '리뷰 번호', value: '#${detail.reviewId}'),
            _InfoRow(label: '학생', value: detail.reviewerName),
            _InfoRow(
              label: '학년/학과',
              value: '${detail.reviewerGrade}학년 · ${detail.reviewerDepartment}',
            ),
            _InfoRow(
              label: '리뷰 작성일',
              value: detail.reviewCreatedAt == null
                  ? '-'
                  : formatter.format(detail.reviewCreatedAt!.toLocal()),
            ),
            _InfoRow(
              label: '신고 작성일',
              value: detail.reportCreatedAt == null
                  ? '-'
                  : formatter.format(detail.reportCreatedAt!.toLocal()),
            ),
          ],
        ),
        AppGap.v16,
        _ContentCard(title: '리뷰 내용', content: detail.reviewContent),
        AppGap.v16,
        _ContentCard(title: '신고 사유', content: detail.reportContent),
        if (detail.deletedAt != null || (detail.deletedBy?.isNotEmpty ?? false)) ...[
          AppGap.v16,
          _InfoCard(
            title: '삭제 정보',
            rows: [
              if (detail.deletedAt != null)
                _InfoRow(
                  label: '삭제 시각',
                  value: formatter.format(detail.deletedAt!.toLocal()),
                ),
              if (detail.deletedBy?.isNotEmpty ?? false)
                _InfoRow(label: '삭제자', value: detail.deletedBy!),
            ],
          ),
        ],
        const Spacer(),
        if (detail.reportStatus == ReportStatus.pending)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _resolve(ReportStatus.rejected),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: AppColors.negative),
                  ),
                  child: const Text(
                    '반려',
                    style: TextStyle(color: AppColors.negative),
                  ),
                ),
              ),
              AppGap.h12,
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _resolve(ReportStatus.approved),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.admin,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_isSubmitting ? '처리 중...' : '승인'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _resolve(ReportStatus status) async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(pendingReportsProvider.notifier).resolve(
            reportId: widget.reportId,
            reportStatus: status,
          );
      ref.invalidate(reportDetailProvider(widget.reportId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == ReportStatus.approved ? '신고를 승인했어요.' : '신고를 반려했어요.',
          ),
        ),
      );
    } on ReportAdminException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.text1.copyWith(color: context.mainTextColor),
          ),
          AppGap.v12,
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 88,
                    child: Text(
                      row.label,
                      style: AppTextStyles.caption1.copyWith(
                        color: context.sub2Color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.value,
                      style: AppTextStyles.text2.copyWith(
                        color: context.mainTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.text1.copyWith(color: context.mainTextColor),
          ),
          AppGap.v12,
          Text(
            content.isEmpty ? '-' : content,
            style: AppTextStyles.text2.copyWith(color: context.mainTextColor),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;
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
