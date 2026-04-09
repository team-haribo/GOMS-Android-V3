import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  MemberFilterSheetSelection copyWith({
    int? grade,
    String? gender,
    String? department,
    String? status,
    String? role,
    bool clearGrade = false,
    bool clearGender = false,
    bool clearDepartment = false,
    bool clearStatus = false,
    bool clearRole = false,
  }) {
    return MemberFilterSheetSelection(
      grade: clearGrade ? null : (grade ?? this.grade),
      gender: clearGender ? null : (gender ?? this.gender),
      department: clearDepartment ? null : (department ?? this.department),
      status: clearStatus ? null : (status ?? this.status),
      role: clearRole ? null : (role ?? this.role),
    );
  }
}

final _memberFilterSelectionProvider =
    NotifierProvider.autoDispose.family<
      _MemberFilterSelectionNotifier,
      MemberFilterSheetSelection,
      (Object, MemberFilterSheetSelection)
    >(_MemberFilterSelectionNotifier.new);

class _MemberFilterSelectionNotifier extends Notifier<MemberFilterSheetSelection> {
  _MemberFilterSelectionNotifier(this.args);

  final (Object, MemberFilterSheetSelection) args;

  @override
  MemberFilterSheetSelection build() => args.$2;

  void setSelection(MemberFilterSheetSelection selection) => state = selection;
}

class MemberFilterBottomSheet extends ConsumerStatefulWidget {
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
  ConsumerState<MemberFilterBottomSheet> createState() =>
      _MemberFilterBottomSheetState();
}

class _MemberFilterBottomSheetState extends ConsumerState<MemberFilterBottomSheet> {
  late final Object _providerIdentity;

  (Object, MemberFilterSheetSelection) get _providerKey =>
      (_providerIdentity, widget.initialSelection);

  @override
  void initState() {
    super.initState();
    _providerIdentity = Object();
  }

  @override
  Widget build(BuildContext context) {
    final selection = ref.watch(_memberFilterSelectionProvider(_providerKey));

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
                      selection.role == 'ROLE_STUDENT' &&
                      selection.status != 'CANNOT_OUTING',
                  onChanged: (selected) {
                    _updateSelection(
                      !selected
                          ? selection.copyWith(clearRole: true)
                          : selection.copyWith(
                              role: 'ROLE_STUDENT',
                              clearStatus:
                                  selection.status == 'CANNOT_OUTING',
                            ),
                    );
                  },
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '학생회',
                  selected: selection.role == 'ROLE_STUDENT_COUNCIL',
                  onChanged: (selected) => _updateSelection(
                    selected
                        ? selection.copyWith(
                            role: 'ROLE_STUDENT_COUNCIL',
                            clearStatus: selection.status == 'CANNOT_OUTING',
                          )
                        : selection.copyWith(clearRole: true),
                  ),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '외출 금지',
                  selected: selection.status == 'CANNOT_OUTING',
                  onChanged: (selected) => _updateSelection(
                    selected
                        ? selection.copyWith(
                            status: 'CANNOT_OUTING',
                            role: 'ROLE_STUDENT',
                          )
                        : selection.copyWith(clearStatus: true),
                  ),
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
                  selected: selection.grade == 1,
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      grade: selected ? 1 : null,
                      clearGrade: !selected,
                    ),
                  ),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '2학년',
                  selected: selection.grade == 2,
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      grade: selected ? 2 : null,
                      clearGrade: !selected,
                    ),
                  ),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '3학년',
                  selected: selection.grade == 3,
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      grade: selected ? 3 : null,
                      clearGrade: !selected,
                    ),
                  ),
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
                  selected: selection.gender == 'MALE',
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      gender: selected ? 'MALE' : null,
                      clearGender: !selected,
                    ),
                  ),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: '여성',
                  selected: selection.gender == 'FEMALE',
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      gender: selected ? 'FEMALE' : null,
                      clearGender: !selected,
                    ),
                  ),
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
                  selected: selection.department == 'SW',
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      department: selected ? 'SW' : null,
                      clearDepartment: !selected,
                    ),
                  ),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: 'iot',
                  selected: selection.department == 'IOT',
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      department: selected ? 'IOT' : null,
                      clearDepartment: !selected,
                    ),
                  ),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CategoryChip(
                  category: 'ai',
                  selected: selection.department == 'AI',
                  onChanged: (selected) => _updateSelection(
                    selection.copyWith(
                      department: selected ? 'AI' : null,
                      clearDepartment: !selected,
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
          AppGap.v12,
        ],
      ),
    );
  }

  void _handleReset() {
    ref
        .read(_memberFilterSelectionProvider(_providerKey).notifier)
        .setSelection(const MemberFilterSheetSelection());
    widget.onReset?.call();
    Navigator.pop(context);
  }

  void _updateSelection(MemberFilterSheetSelection selection) {
    ref
        .read(_memberFilterSelectionProvider(_providerKey).notifier)
        .setSelection(selection);
    _notifySelectionChanged(selection);
  }

  void _notifySelectionChanged(MemberFilterSheetSelection selection) {
    widget.onApply?.call(selection);
  }
}
