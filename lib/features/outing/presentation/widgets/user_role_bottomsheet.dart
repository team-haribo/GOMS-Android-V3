import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';
import 'package:goms/core/widgets/buttons/toggle_button.dart';
import 'package:goms/core/widgets/dialogs/banned_outing_dialog.dart';
import 'package:goms/core/widgets/dialogs/banned_outing_release_dialog.dart';
import 'package:goms/core/widgets/dialogs/force_outing_dialog.dart';
import 'package:goms/core/widgets/dialogs/forced_outing_release_dialog.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/presentation/providers/student_council_members_provider.dart';
import 'package:goms/features/outing/data/providers/outing_data_providers.dart';

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
