import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';
import 'package:goms/core/widgets/chips/category_chip.dart';

class MemberFilterSheetSelection {
  const MemberFilterSheetSelection({
    this.grade,
    this.gender,
    this.department,
    this.status,
    this.role,
  });

  final int? grade;
  final String? gender;
  final String? department;
  final String? status;
  final String? role;
}

class MemberFilterBottomSheet extends StatefulWidget {
  const MemberFilterBottomSheet({
    super.key,
    this.initialSelection = const MemberFilterSheetSelection(),
    this.onApply,
    this.onReset,
  });

  final MemberFilterSheetSelection initialSelection;
  final ValueChanged<MemberFilterSheetSelection>? onApply;
  final VoidCallback? onReset;

  @override
  State<MemberFilterBottomSheet> createState() =>
      _MemberFilterBottomSheetState();
}

class _MemberFilterBottomSheetState extends State<MemberFilterBottomSheet> {
  int? _grade;
  String? _gender;
  String? _department;
  String? _status;
  String? _role;

  @override
  void initState() {
    super.initState();
    _grade = widget.initialSelection.grade;
    _gender = widget.initialSelection.gender;
    _department = widget.initialSelection.department;
    _status = widget.initialSelection.status;
    _role = widget.initialSelection.role;
  }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '필터',
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '역할',
            style: AppTextStyles.title3.copyWith(
              color: context.isLightMode ? Colors.black : Colors.white,
            ),
          ),
          AppGap.v12,
          Row(
            children: [
              Expanded(
                child: CategoryChip(
                  category: '학생',
                  selected:
                      _role == 'ROLE_STUDENT' && _status != 'CANNOT_OUTING',
                  onChanged: (selected) {
                    setState(() {
                      if (!selected) {
                        _role = null;
                      } else {
                        _role = 'ROLE_STUDENT';
                        if (_status == 'CANNOT_OUTING') {
                          _status = null;
                        }
                      }
                    });
                    _notifySelectionChanged();
                  },
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '학생회',
                  selected: _role == 'ROLE_STUDENT_COUNCIL',
                  onChanged: (selected) {
                    setState(() {
                      _role = selected ? 'ROLE_STUDENT_COUNCIL' : null;
                      if (selected && _status == 'CANNOT_OUTING') {
                        _status = null;
                      }
                    });
                    _notifySelectionChanged();
                  },
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '외출 금지',
                  selected: _status == 'CANNOT_OUTING',
                  onChanged: (selected) {
                    setState(() {
                      _status = selected ? 'CANNOT_OUTING' : null;
                      if (selected) {
                        _role = 'ROLE_STUDENT';
                      }
                    });
                    _notifySelectionChanged();
                  },
                ),
              ),
            ],
          ),
          AppGap.v24,
          Text(
            '학년',
            style: AppTextStyles.title3.copyWith(
              color: context.isLightMode ? Colors.black : Colors.white,
            ),
          ),
          AppGap.v12,
          Row(
            children: [
              Expanded(
                child: CategoryChip(
                  category: '1학년',
                  selected: _grade == 1,
                  onChanged: (selected) => setState(() {
                    _grade = selected ? 1 : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '2학년',
                  selected: _grade == 2,
                  onChanged: (selected) => setState(() {
                    _grade = selected ? 2 : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '3학년',
                  selected: _grade == 3,
                  onChanged: (selected) => setState(() {
                    _grade = selected ? 3 : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
            ],
          ),
          AppGap.v24,
          Text(
            '성별',
            style: AppTextStyles.title3.copyWith(
              color: context.isLightMode ? Colors.black : Colors.white,
            ),
          ),
          AppGap.v12,
          Row(
            children: [
              Expanded(
                child: CategoryChip(
                  category: '남성',
                  selected: _gender == 'MALE',
                  onChanged: (selected) => setState(() {
                    _gender = selected ? 'MALE' : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '여성',
                  selected: _gender == 'FEMALE',
                  onChanged: (selected) => setState(() {
                    _gender = selected ? 'FEMALE' : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
            ],
          ),
          AppGap.v24,
          Text(
            '학과',
            style: AppTextStyles.title3.copyWith(
              color: context.isLightMode ? Colors.black : Colors.white,
            ),
          ),
          AppGap.v12,
          Row(
            children: [
              Expanded(
                child: CategoryChip(
                  category: 'sw',
                  selected: _department == 'SW',
                  onChanged: (selected) => setState(() {
                    _department = selected ? 'SW' : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: 'iot',
                  selected: _department == 'IOT',
                  onChanged: (selected) => setState(() {
                    _department = selected ? 'IOT' : null;
                    _notifySelectionChanged();
                  }),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: 'ai',
                  selected: _department == 'AI',
                  onChanged: (selected) => setState(() {
                    _department = selected ? 'AI' : null;
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
          AppGap.v12,
        ],
      ),
    );
  }

  void _handleReset() {
    setState(() {
      _grade = null;
      _gender = null;
      _department = null;
      _status = null;
      _role = null;
    });
    widget.onReset?.call();
    Navigator.pop(context);
  }

  void _notifySelectionChanged() {
    widget.onApply?.call(
      MemberFilterSheetSelection(
        grade: _grade,
        gender: _gender,
        department: _department,
        status: _status,
        role: _role,
      ),
    );
  }
}
