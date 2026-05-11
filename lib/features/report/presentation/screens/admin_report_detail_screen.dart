import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/presentation/models/report_detail_model.dart';
import 'package:goms/features/report/presentation/providers/admin_report_providers.dart';
import 'package:intl/intl.dart';

final _reportResolveSubmittingProvider = NotifierProvider.autoDispose
    .family<_ReportResolveSubmittingNotifier, bool, int>(
  _ReportResolveSubmittingNotifier.new,
);

class _ReportResolveSubmittingNotifier extends Notifier<bool> {
  _ReportResolveSubmittingNotifier(this.reportId);

  final int reportId;

  @override
  bool build() => false;

  void setSubmitting(bool value) => state = value;
}

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
  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(reportDetailProvider(widget.reportId));
    final isSubmitting = ref.watch(
      _reportResolveSubmittingProvider(widget.reportId),
    );

    return BaseScaffold(
      showAppBar: true,
      role: RoleEnum.admin,
      body: detailAsync.when(
        data: (detail) => _buildContent(context, detail, isSubmitting),
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

  Widget _buildContent(
    BuildContext context,
    ReportDetailModel detail,
    bool isSubmitting,
  ) {
    final reportCreatedAt = _formatDateTime(detail.reportCreatedAt);
    final reviewCreatedAt = _formatDateTime(detail.reviewCreatedAt);
    final reviewMeta = _buildReviewMeta(detail, reviewCreatedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '신고 조회',
                style: AppTextStyles.title1.copyWith(
                  color: context.mainTextColor,
                ),
              ),
            ),
            const Spacer(),
            _StatusText(status: detail.reportStatus),
          ],
        ),
        AppGap.v24,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(title: '신고 내용'),
                AppGap.v12,
                _ContentBox(content: detail.reportContent),
                AppGap.v4,
                _MetaText(text: reportCreatedAt, align: TextAlign.right),
                AppGap.v16,
                const _SectionTitle(title: '신고 대상자'),
                AppGap.v12,
                _ReportedUserTile(detail: detail),
                AppGap.v16,
                const _SectionTitle(title: '후기 내용'),
                AppGap.v12,
                _ContentBox(content: detail.reviewContent),
                AppGap.v4,
                _MetaText(text: reviewMeta),
              ],
            ),
          ),
        ),
        AppGap.v20,
        if (detail.reportStatus == ReportStatus.pending)
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: '기각',
                  backgroundColor: context.buttonColor,
                  foregroundColor: context.sub2Color,
                  onPressed: isSubmitting
                      ? null
                      : () => _resolve(ReportStatus.rejected),
                ),
              ),
              AppGap.h12,
              Expanded(
                child: _ActionButton(
                  label: isSubmitting ? '처리 중...' : '리뷰 삭제',
                  backgroundColor: AppColors.negative,
                  foregroundColor: Colors.white,
                  onPressed: isSubmitting
                      ? null
                      : () => _resolve(ReportStatus.approved),
                ),
              ),
            ],
          ),
      ],
    );
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('yy.MM.dd HH:mm:ss').format(value.toLocal());
  }

  String _buildReviewMeta(ReportDetailModel detail, String reviewCreatedAt) {
    final placeName = detail.placeName?.trim();
    final segments = <String>[
      if (placeName != null && placeName.isNotEmpty) placeName,
      if (reviewCreatedAt != '-') reviewCreatedAt,
    ];

    if (segments.isEmpty) {
      return '리뷰 #${detail.reviewId}';
    }

    return segments.join(' ');
  }

  Future<void> _resolve(ReportStatus status) async {
    ref
        .read(_reportResolveSubmittingProvider(widget.reportId).notifier)
        .setSubmitting(true);
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
            status == ReportStatus.approved ? '리뷰를 삭제했어요.' : '신고를 기각했어요.',
          ),
        ),
      );
    } on ReportAdminException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      ref
          .read(_reportResolveSubmittingProvider(widget.reportId).notifier)
          .setSubmitting(false);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.title3.copyWith(color: context.mainTextColor),
    );
  }
}

class _ContentBox extends StatelessWidget {
  const _ContentBox({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        content.isEmpty ? '-' : content,
        style: AppTextStyles.text2.copyWith(color: context.sub1Color),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({
    required this.text,
    this.align = TextAlign.left,
  });

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        textAlign: align,
        style: AppTextStyles.caption1.copyWith(color: context.sub2Color),
      ),
    );
  }
}

class _ReportedUserTile extends StatelessWidget {
  const _ReportedUserTile({required this.detail});

  final ReportDetailModel detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          radius: 22,
          imageUrl: detail.reviewerProfileImageUrl,
          backgroundColor: context.surfaceColor,
        ),
        AppGap.h12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.reviewerName,
                style: AppTextStyles.text1.copyWith(
                  color: context.mainTextColor,
                ),
              ),
              AppGap.v2,
              Text(
                '${detail.reviewerGrade}기 ${detail.reviewerDepartment}',
                style: AppTextStyles.caption1.copyWith(
                  color: context.sub2Color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isDisabled
              ? backgroundColor.withValues(alpha: 0.6)
              : backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.text1.copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.status});

  final ReportStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReportStatus.pending => ('처리전', AppColors.admin),
      ReportStatus.approved => ('처리 완료', context.sub2Color),
      ReportStatus.rejected => ('기각', context.sub2Color),
    };

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        label,
        style: AppTextStyles.caption1.copyWith(color: color),
      ),
    );
  }
}
