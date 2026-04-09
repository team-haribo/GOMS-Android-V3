import 'package:flutter/material.dart';
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
}

class ReportFilterBottomSheet extends StatefulWidget {
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
  State<ReportFilterBottomSheet> createState() =>
      _ReportFilterBottomSheetState();
}

class _ReportFilterBottomSheetState extends State<ReportFilterBottomSheet> {
  ReportStatus? _reportStatus;

  @override
  void initState() {
    super.initState();
    _reportStatus = widget.initialSelection.reportStatus;
  }

  @override
  Widget build(BuildContext context) {
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
                  selected: _reportStatus == ReportStatus.pending,
                  onChanged: (selected) => setState(() {
                    _reportStatus = selected ? ReportStatus.pending : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '처리완료',
                  selected: _reportStatus == ReportStatus.approved,
                  onChanged: (selected) => setState(() {
                    _reportStatus = selected ? ReportStatus.approved : null;
                    _notifySelectionChanged();
                  }),
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
    setState(() {
      _reportStatus = null;
    });
    widget.onReset?.call();
    Navigator.pop(context);
  }

  void _notifySelectionChanged() {
    widget.onApply?.call(
      ReportFilterSelection(reportStatus: _reportStatus),
    );
  }
}
