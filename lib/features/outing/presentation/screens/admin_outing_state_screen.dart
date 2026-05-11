import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/utils/student_info_formatter.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/data/request/student_council_filter_request.dart';
import 'package:goms/features/member/presentation/providers/student_council_members_provider.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';
// ui
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';
import 'package:goms/core/widgets/bottom_sheets/filter_button.dart';
import 'package:goms/core/widgets/buttons/qr_button.dart';
import 'package:goms/core/widgets/buttons/toggle_button.dart';
import 'package:goms/core/widgets/chips/category_chip.dart';
import 'package:goms/core/widgets/dialogs/banned_outing_dialog.dart';
import 'package:goms/core/widgets/dialogs/banned_outing_release_dialog.dart';
import 'package:goms/core/widgets/dialogs/force_outing_dialog.dart';
import 'package:goms/core/widgets/dialogs/forced_outing_release_dialog.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';

class AdminOutingStateScreen extends ConsumerStatefulWidget {
  const AdminOutingStateScreen({
    super.key,
  });

  @override
  ConsumerState<AdminOutingStateScreen> createState() =>
      _AdminOutingStateScreen();
}

class _AdminOutingStateScreen extends ConsumerState<AdminOutingStateScreen> {
  bool isOutingDay = true;

  @override
  Widget build(BuildContext context) {
    final searchText = ref.watch(studentCouncilMemberSearchProvider);
    final membersAsync = ref.watch(studentCouncilMembersProvider);
    final role = ref.watch(roleProvider);

    return BaseScaffold(
      showAppBar: true,
      role: role,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '외출제 관리',
                  style: AppTextStyles.title1.copyWith(
                    color: context.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
          AppGap.v24,
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.surfaceColor,
              ),
              child: SearchStudentField(
                onChanged: (value) {
                  ref.read(studentCouncilMemberSearchProvider.notifier).state =
                      value;
                },
              ),
            ),
          ),
          if (!isOutingDay)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.coffee(),
                    AppGap.v8,
                    Text(
                      '오늘은 외출하는 날이 아니에요!',
                      style: AppTextStyles.title1
                          .copyWith(fontSize: 14, color: AppColors.sub2),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            AppGap.v12,
            Row(
              children: [
                Expanded(
                  child: Text(
                    '검색결과',
                    style: AppTextStyles.title3.copyWith(
                      color: context.mainTextColor,
                    ),
                  ),
                ),
                FilterButton(
                  bottomSheetBuilder: (_) => MemberFilterBottomSheet(
                    initialSelection: _selectionFromFilter(
                      ref.read(studentCouncilMemberFilterProvider),
                    ),
                    onReset: () {
                      ref
                          .read(studentCouncilMembersProvider.notifier)
                          .clearFilter();
                      ref.read(studentCouncilMembersProvider.notifier).reload();
                    },
                    onApply: (selection) {
                      ref
                          .read(studentCouncilMembersProvider.notifier)
                          .updateFilter(
                            StudentCouncilFilterRequest(
                              grade: selection.grade,
                              gender: selection.gender,
                              department: selection.department,
                              status: selection.status,
                              role: selection.role,
                            ),
                          );
                      ref.read(studentCouncilMembersProvider.notifier).reload();
                    },
                  ),
                ),
              ],
            ),
            AppGap.v8,
            Expanded(
              child: RefreshIndicator(
                color: AppColors.admin,
                onRefresh: () {
                  return ref
                      .read(studentCouncilMembersProvider.notifier)
                      .reload();
                },
                child: membersAsync.when(
                  data: (members) {
                    final filteredMembers = searchText.trim().isEmpty
                        ? members
                        : members
                            .where(
                              (member) => member.name
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()),
                            )
                            .toList();

                    if (filteredMembers.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 280,
                            child: Center(
                              child: Text(
                                searchText.trim().isEmpty
                                    ? '조회된 학생이 없어요.'
                                    : '검색 결과가 없어요.',
                                style: AppTextStyles.text2.copyWith(
                                  color: context.sub2Color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
                        return AdminOutingStateContainer(
                          memberId: member.memberId,
                          name: member.name,
                          grade: member.grade,
                          major: member.department,
                          profileImageUrl: member.profileImageUrl,
                          studentRole: member.studentRole,
                          status: member.status,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 1,
                          color: context.buttonColor,
                        );
                      },
                    );
                  },
                  loading: () => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(
                        height: 280,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                  error: (error, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 280,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                error is StudentCouncilMembersException
                                    ? error.message
                                    : '학생 목록을 불러오지 못했어요.',
                                style: AppTextStyles.text2.copyWith(
                                  color: context.sub2Color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              AppGap.v12,
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(
                                        studentCouncilMembersProvider.notifier,
                                      )
                                      .reload();
                                },
                                child: const Text('다시 시도'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: QRButton(type: role),
    );
  }

  MemberFilterSheetSelection _selectionFromFilter(
    StudentCouncilFilterRequest filter,
  ) {
    return MemberFilterSheetSelection(
      grade: filter.grade,
      gender: filter.gender,
      department: filter.department,
      status: filter.status,
      role: filter.role,
    );
  }
}

// ---------------------------------------------------------------------------
// MemberFilterBottomSheet (moved from widgets/member_filter_bottom_sheet.dart)
// ---------------------------------------------------------------------------

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

final _memberFilterSelectionProvider = NotifierProvider.autoDispose.family<
    _MemberFilterSelectionNotifier,
    MemberFilterSheetSelection,
    (Object, MemberFilterSheetSelection)>(_MemberFilterSelectionNotifier.new);

class _MemberFilterSelectionNotifier
    extends Notifier<MemberFilterSheetSelection> {
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

class _MemberFilterBottomSheetState
    extends ConsumerState<MemberFilterBottomSheet> {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  selected: selection.role == 'ROLE_STUDENT' &&
                      selection.status != 'CANNOT_OUTING',
                  onChanged: (selected) {
                    _updateSelection(
                      !selected
                          ? selection.copyWith(clearRole: true)
                          : selection.copyWith(
                              role: 'ROLE_STUDENT',
                              clearStatus: selection.status == 'CANNOT_OUTING',
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

// ---------------------------------------------------------------------------
// AdminOutingStateContainer (moved from widgets/admin_outing_state_container.dart)
// AdminBottomSheet eliminated — inlined as UserRoleBottomSheet(maxHeightRatio: 1)
// ---------------------------------------------------------------------------

class _AdminOutingStudentState {
  const _AdminOutingStudentState({
    required this.role,
    required this.status,
  });

  final StudentRole role;
  final String status;

  _AdminOutingStudentState copyWith({
    StudentRole? role,
    String? status,
  }) {
    return _AdminOutingStudentState(
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}

final _adminOutingStudentRoleProvider = NotifierProvider.autoDispose.family<
    _AdminOutingStudentRoleNotifier,
    _AdminOutingStudentState,
    (Object, StudentRole, String)>(_AdminOutingStudentRoleNotifier.new);

class _AdminOutingStudentRoleNotifier
    extends Notifier<_AdminOutingStudentState> {
  _AdminOutingStudentRoleNotifier(this.args);

  final (Object, StudentRole, String) args;

  @override
  _AdminOutingStudentState build() =>
      _AdminOutingStudentState(role: args.$2, status: args.$3);

  void update({
    StudentRole? role,
    String? status,
  }) {
    state = state.copyWith(role: role, status: status);
  }
}

class AdminOutingStateContainer extends ConsumerStatefulWidget {
  final int memberId;
  final String name;
  final int grade;
  final String major;
  final StudentRole studentRole;
  final String profileImageUrl;
  final String status;

  const AdminOutingStateContainer({
    super.key,
    required this.memberId,
    required this.name,
    required this.grade,
    required this.major,
    required this.studentRole,
    required this.profileImageUrl,
    required this.status,
  });

  @override
  ConsumerState<AdminOutingStateContainer> createState() =>
      _AdminOutingStateContainerState();
}

class _AdminOutingStateContainerState
    extends ConsumerState<AdminOutingStateContainer> {
  late final Object _providerIdentity;

  (Object, StudentRole, String) get _providerKey =>
      (_providerIdentity, widget.studentRole, widget.status);

  @override
  void initState() {
    super.initState();
    _providerIdentity = Object();
  }

  @override
  Widget build(BuildContext context) {
    final studentState =
        ref.watch(_adminOutingStudentRoleProvider(_providerKey));
    final studentRole = studentState.role;

    return Container(
      color: context.backgroundColor,
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: studentRole == StudentRole.council
                      ? AppColors.admin
                      : studentRole == StudentRole.outingBanned
                          ? AppColors.negative
                          : Colors.transparent,
                  width: 4,
                ),
              ),
              child: ProfileAvatar(
                radius: studentRole == StudentRole.outingBanned ||
                        studentRole == StudentRole.council
                    ? 22
                    : 24,
                imageUrl: widget.profileImageUrl,
                backgroundColor: context.surfaceColor,
              ),
            ),
          ),
          AppGap.v4,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: AppTextStyles.text1.copyWith(
                  color: studentRole == StudentRole.outingBanned
                      ? AppColors.negative
                      : studentRole == StudentRole.council
                          ? AppColors.admin
                          : context.sub1Color,
                ),
              ),
              AppGap.h4,
              Text(
                StudentInfoFormatter.formatCohortDepartment(
                  grade: widget.grade,
                  department: widget.major,
                ),
                style: AppTextStyles.caption2.copyWith(
                  color: context.sub2Color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  backgroundColor: context.surfaceColor,
                  builder: (context) => UserRoleBottomSheet(
                    memberId: widget.memberId,
                    studentRole: studentRole,
                    status: studentState.status,
                    maxHeightRatio: 1,
                    onRoleChanged: (newRole) {
                      ref
                          .read(
                            _adminOutingStudentRoleProvider(
                              _providerKey,
                            ).notifier,
                          )
                          .update(role: newRole);
                    },
                    onStatusChanged: (newStatus) {
                      ref
                          .read(
                            _adminOutingStudentRoleProvider(
                              _providerKey,
                            ).notifier,
                          )
                          .update(status: newStatus);
                    },
                  ),
                );
              },
              icon: AppIcons.tablerEdit(
                color: context.sub2Color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// UserRoleBottomSheet (moved from widgets/user_role_bottomsheet.dart)
// ---------------------------------------------------------------------------

class _UserRoleBottomSheetStateModel {
  const _UserRoleBottomSheetStateModel({
    required this.isOutingBanned,
    required this.isCouncil,
    required this.isOuting,
    required this.isSubmitting,
  });

  factory _UserRoleBottomSheetStateModel.fromRole(
    StudentRole role,
    String status,
  ) {
    return _UserRoleBottomSheetStateModel(
      isOutingBanned: role == StudentRole.outingBanned,
      isCouncil: role == StudentRole.council,
      isOuting: status == 'OUTING',
      isSubmitting: false,
    );
  }

  final bool isOutingBanned;
  final bool isCouncil;
  final bool isOuting;
  final bool isSubmitting;

  StudentRole get currentRole {
    if (isCouncil) return StudentRole.council;
    if (isOutingBanned) return StudentRole.outingBanned;
    return StudentRole.student;
  }

  _UserRoleBottomSheetStateModel copyWith({
    bool? isOutingBanned,
    bool? isCouncil,
    bool? isOuting,
    bool? isSubmitting,
  }) {
    return _UserRoleBottomSheetStateModel(
      isOutingBanned: isOutingBanned ?? this.isOutingBanned,
      isCouncil: isCouncil ?? this.isCouncil,
      isOuting: isOuting ?? this.isOuting,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final _userRoleBottomSheetStateProvider = NotifierProvider.autoDispose.family<
    _UserRoleBottomSheetStateNotifier,
    _UserRoleBottomSheetStateModel,
    (Object, StudentRole, String)>(
  _UserRoleBottomSheetStateNotifier.new,
);

class _UserRoleBottomSheetStateNotifier
    extends Notifier<_UserRoleBottomSheetStateModel> {
  _UserRoleBottomSheetStateNotifier(this.args);

  final (Object, StudentRole, String) args;

  @override
  _UserRoleBottomSheetStateModel build() =>
      _UserRoleBottomSheetStateModel.fromRole(args.$2, args.$3);

  void update(
    _UserRoleBottomSheetStateModel Function(
      _UserRoleBottomSheetStateModel state,
    ) transform,
  ) {
    state = transform(state);
  }
}

class UserRoleBottomSheet extends ConsumerStatefulWidget {
  const UserRoleBottomSheet({
    super.key,
    required this.memberId,
    required this.studentRole,
    required this.status,
    required this.onRoleChanged,
    required this.onStatusChanged,
    this.maxHeightRatio = 0.8,
  });

  final int memberId;
  final StudentRole studentRole;
  final String status;
  final Function(StudentRole) onRoleChanged;
  final ValueChanged<String> onStatusChanged;
  final double maxHeightRatio;

  @override
  ConsumerState<UserRoleBottomSheet> createState() =>
      _UserRoleBottomSheetState();
}

class _UserRoleBottomSheetState extends ConsumerState<UserRoleBottomSheet> {
  late final Object _providerIdentity;

  (Object, StudentRole, String) get _providerKey =>
      (_providerIdentity, widget.studentRole, widget.status);

  @override
  void initState() {
    super.initState();
    _providerIdentity = Object();
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(_userRoleBottomSheetStateProvider(_providerKey));

    return CommonBottomSheet(
      title: '유저 권한 변경',
      maxHeightRatio: widget.maxHeightRatio,
      onClose: uiState.isSubmitting ? null : () => Navigator.pop(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (uiState.currentRole == StudentRole.student)
            _UserRoleBottomSheetItem(
              title: '외출',
              description: '학생들 외출/복귀 시켜요.',
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ToggleButton(
                  type: RoleEnum.admin,
                  value: uiState.isOuting,
                  onChanged: uiState.isSubmitting
                      ? (_) {}
                      : (_) {
                          if (uiState.isOuting) {
                            forcedOutingRelease(
                              context: context,
                              title: '강제외출 복귀',
                              content: '\n 학생을 복귀 상태로 변경하시겠습니까?',
                              onConfirm: _releaseForcedOuting,
                            );
                          } else {
                            forcedOuting(
                              context: context,
                              title: '강제외출',
                              content: '\n 이 학생을 외출 상태로 변경하시겠습니까?',
                              onConfirm: _forceOut,
                            );
                          }
                        },
                ),
              ),
            ),
          if (uiState.currentRole == StudentRole.student ||
              uiState.currentRole == StudentRole.outingBanned) ...[
            AppGap.v12,
            _UserRoleBottomSheetItem(
              title: '외출금지',
              description: '이 학생은 외출할 수 없어요',
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ToggleButton(
                  type: RoleEnum.admin,
                  value: uiState.isOutingBanned,
                  onChanged: uiState.isSubmitting
                      ? (_) {}
                      : (value) {
                          if (uiState.isOutingBanned) {
                            bannedOutingRelease(
                              context: context,
                              title: '외출금지',
                              content: '\n이 학생을',
                              redContent: ' 외출금지 해제 ',
                              content2: '시키겠습니까?',
                              onConfirm: () => _updateOutingAllowed(true),
                            );
                          } else {
                            bannedOuting(
                              context: context,
                              title: '외출금지',
                              content: '\n이 학생을',
                              redContent: ' 외출금지 ',
                              content2: '시키겠습니까?',
                              onConfirm: () => _updateOutingAllowed(false),
                            );
                          }
                        },
                ),
              ),
            ),
          ],
          AppGap.v12,
          _UserRoleBottomSheetItem(
            title: '학생회 권한 부여',
            description: '이 학생은 학생회 권한을 가지게 돼요',
            trailing: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ToggleButton(
                type: RoleEnum.admin,
                value: uiState.isCouncil,
                onChanged: uiState.isSubmitting ? (_) {} : _updateCouncil,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCouncil(bool value) async {
    await _runAction(
      () => ref.read(memberRepositoryProvider).updateStudentCouncilRole(
            memberId: widget.memberId,
            isCouncil: value,
          ),
      onSuccess: () {
        if (!mounted) return;
        final nextRole = value ? StudentRole.council : StudentRole.student;
        ref.read(studentCouncilMembersProvider.notifier).updateMemberRole(
              memberId: widget.memberId,
              studentRole: nextRole,
            );
        _updateUiState(
          (state) => state.copyWith(
            isCouncil: value,
            isOutingBanned: value ? false : state.isOutingBanned,
          ),
        );
        widget.onRoleChanged(nextRole);
      },
    );
  }

  Future<void> _updateOutingAllowed(bool isAllowed) async {
    await _runAction(
      () =>
          ref.read(memberRepositoryProvider).updateStudentCouncilOutingAllowed(
                memberId: widget.memberId,
                isAllowed: isAllowed,
              ),
      onSuccess: () {
        if (!mounted) return;
        final nextRole =
            isAllowed ? StudentRole.student : StudentRole.outingBanned;
        ref.read(studentCouncilMembersProvider.notifier).updateMemberRole(
              memberId: widget.memberId,
              studentRole: nextRole,
            );
        _updateUiState(
          (state) => state.copyWith(
            isOutingBanned: !isAllowed,
            isCouncil: isAllowed ? state.isCouncil : false,
          ),
        );
        widget.onRoleChanged(nextRole);
      },
    );
  }

  Future<void> _forceOut() async {
    await _runAction(
      () => ref.read(outingRepositoryProvider).forceOutStudent(
            memberId: widget.memberId,
          ),
      onSuccess: () {
        if (!mounted) return;
        ref.read(studentCouncilMembersProvider.notifier).updateMemberStatus(
              memberId: widget.memberId,
              status: 'OUTING',
            );
        _updateUiState((state) => state.copyWith(isOuting: true));
        widget.onStatusChanged('OUTING');
      },
    );
  }

  Future<void> _releaseForcedOuting() async {
    await _runAction(
      () => ref.read(outingRepositoryProvider).forceInStudent(
            memberId: widget.memberId,
          ),
      onSuccess: () {
        if (!mounted) return;
        ref.read(studentCouncilMembersProvider.notifier).updateMemberStatus(
              memberId: widget.memberId,
              status: 'COMING',
            );
        _updateUiState((state) => state.copyWith(isOuting: false));
        widget.onStatusChanged('COMING');
      },
    );
  }

  Future<void> _runAction(
    Future<void> Function() action, {
    VoidCallback? onSuccess,
  }) async {
    if (ref
        .read(_userRoleBottomSheetStateProvider(_providerKey))
        .isSubmitting) {
      return;
    }

    _updateUiState((state) => state.copyWith(isSubmitting: true));

    try {
      await action();
      onSuccess?.call();
    } on DioException catch (error) {
      _showError(NetworkException.fromDioException(error).message);
    } catch (_) {
      _showError('요청 처리 중 오류가 발생했습니다.');
    } finally {
      _updateUiState((state) => state.copyWith(isSubmitting: false));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _updateUiState(
    _UserRoleBottomSheetStateModel Function(
      _UserRoleBottomSheetStateModel state,
    ) transform,
  ) {
    final notifier = ref.read(
      _userRoleBottomSheetStateProvider(_providerKey).notifier,
    );
    notifier.update(transform);
  }
}

class _UserRoleBottomSheetItem extends StatelessWidget {
  const _UserRoleBottomSheetItem({
    required this.title,
    required this.description,
    required this.trailing,
  });

  final String title;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.text1.copyWith(
                    color: context.mainTextColor,
                  ),
                ),
                AppGap.v4,
                Text(
                  description,
                  style: AppTextStyles.caption1.copyWith(
                    color: context.sub2Color,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
