import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
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

class UserRoleBottomSheet extends ConsumerStatefulWidget {
  const UserRoleBottomSheet({
    super.key,
    required this.memberId,
    required this.studentRole,
    required this.onRoleChanged,
    this.maxHeightRatio = 0.8,
  });

  final int memberId;
  final StudentRole studentRole;
  final Function(StudentRole) onRoleChanged;
  final double maxHeightRatio;

  @override
  ConsumerState<UserRoleBottomSheet> createState() =>
      _UserRoleBottomSheetState();
}

class _UserRoleBottomSheetState extends ConsumerState<UserRoleBottomSheet> {
  bool isOutingBanned = false;
  bool isCouncil = false;
  bool isOuting = false;
  bool _isSubmitting = false;

  StudentRole get _currentRole {
    if (isCouncil) return StudentRole.council;
    if (isOutingBanned) return StudentRole.outingBanned;
    return StudentRole.student;
  }

  @override
  void initState() {
    super.initState();
    isOutingBanned = widget.studentRole == StudentRole.outingBanned;
    isCouncil = widget.studentRole == StudentRole.council;
  }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '유저 권한 변경',
      maxHeightRatio: widget.maxHeightRatio,
      onClose: _isSubmitting ? null : () => Navigator.pop(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentRole == StudentRole.student)
            _UserRoleBottomSheetItem(
              title: isOuting ? '강제외출 복귀' : '강제외출',
              description: isOuting ? '학생을 강제외출 복귀를 시켜요' : '학생을 강제외출 시켜요',
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IconButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (isOuting) {
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
                  icon: isOuting
                      ? AppIcons.forceReturn()
                      : AppIcons.forcedOuting(),
                ),
              ),
            ),
          if (_currentRole == StudentRole.student ||
              _currentRole == StudentRole.outingBanned) ...[
            AppGap.v12,
            _UserRoleBottomSheetItem(
              title: '외출금지',
              description: '이 학생은 외출할 수 없어요',
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ToggleButton(
                  type: RoleEnum.admin,
                  value: isOutingBanned,
                  onChanged: _isSubmitting
                      ? (_) {}
                      : (value) {
                          if (isOutingBanned) {
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
                value: isCouncil,
                onChanged: _isSubmitting ? (_) {} : _updateCouncil,
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
        setState(() {
          isCouncil = value;
          if (value) {
            isOutingBanned = false;
          }
        });
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
        setState(() {
          isOutingBanned = !isAllowed;
          if (!isAllowed) {
            isCouncil = false;
          }
        });
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
        setState(() {
          isOuting = true;
        });
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
        setState(() {
          isOuting = false;
        });
      },
    );
  }

  Future<void> _runAction(
    Future<void> Function() action, {
    VoidCallback? onSuccess,
  }) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await action();
      onSuccess?.call();
    } on DioException catch (error) {
      _showError(NetworkException.fromDioException(error).message);
    } catch (_) {
      _showError('요청 처리 중 오류가 발생했습니다.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message)),
    );
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
