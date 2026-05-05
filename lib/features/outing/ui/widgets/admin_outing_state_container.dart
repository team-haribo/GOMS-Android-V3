import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/utils/student_info_formatter.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/outing/ui/widgets/admin_bottom_sheet.dart';

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
                  builder: (context) => AdminBottomSheet(
                    memberId: widget.memberId,
                    studentRole: studentRole,
                    status: studentState.status,
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
