import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';
import 'package:goms/core/widgets/chips/category_chip.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';

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
      reportStatus: clearReportStatus ? null : (reportStatus ?? this.reportStatus),
    );
  }
}

final _reportFilterSelectionProvider =
    NotifierProvider.autoDispose.family<
      _ReportFilterSelectionNotifier,
      ReportFilterSelection,
      (Object, ReportFilterSelection)
    >(_ReportFilterSelectionNotifier.new);

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

class _ReportFilterBottomSheetState extends ConsumerState<ReportFilterBottomSheet> {
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
