import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/domain/enum/role_enum.dart';
import 'package:goms/domain/enum/student_role_enum.dart';
import 'package:goms/widgets/common/buttons/toggle_button.dart';
import 'package:goms/widgets/common/goms_dialog.dart';

class UserRoleBottomSheet extends StatefulWidget {
  final StudentRole studentRole;
  final Function(StudentRole) onRoleChanged;

  const UserRoleBottomSheet({
    super.key,
    required this.studentRole,
    required this.onRoleChanged,
  });

  @override
  State<UserRoleBottomSheet> createState() => _UserRoleBottomSheetState();
}

class _UserRoleBottomSheetState extends State<UserRoleBottomSheet> {
  bool isOutingBanned = false;
  bool isCouncil = false;
  bool isOuting = false;

  @override
  void initState() {
    super.initState();
    isOutingBanned = widget.studentRole == StudentRole.outingBanned;
    isCouncil = widget.studentRole == StudentRole.council;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '유저 권한 변경',
                  style: AppTextStyles.title3
                      .copyWith(color: isLight ? Colors.black : Colors.white),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: AppIcons.cancel(),
                ),
              ],
            ),
            AppGap.v24,
            if (widget.studentRole == StudentRole.student) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 11.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOuting ? '강제외출 복귀' : '강제외출',
                          style: AppTextStyles.text1.copyWith(
                            color: isLight
                                ? AppColors.mainText
                                : AppColors.mainTextDark,
                          ),
                        ),
                        AppGap.v4,
                        Text(
                          isOuting ? '학생을 강제외출 복귀를 시켜요' : '학생을 강제외출 시켜요',
                          style: AppTextStyles.caption1.copyWith(
                            color:
                                isLight ? AppColors.sub2 : AppColors.sub2Dark,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IconButton(
                        onPressed: () {
                          if (isOuting) {
                            GomsDialog.forcedOutingRelease(
                              context: context,
                              title: '강제외출 복귀',
                              content: '\n 학생을 복귀 상태로 변경하시겠습니까?',
                              onConfirm: () {
                                setState(() {
                                  isOuting = false;
                                });
                              },
                            );
                          } else {
                            GomsDialog.forcedOuting(
                              context: context,
                              title: '강제외출',
                              content: '\n 이 학생을 외출 상태로 변경하시겠습니까?',
                              onConfirm: () {
                                setState(() {
                                  isOuting = true;
                                });
                              },
                            );
                          }
                        },
                        icon: isOuting
                            ? AppIcons.forceReturn()
                            : AppIcons.forcedOuting(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.studentRole == StudentRole.student ||
                widget.studentRole == StudentRole.outingBanned) ...[
              AppGap.v12,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 11.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '외출금지',
                          style: AppTextStyles.text1.copyWith(
                            color: isLight
                                ? AppColors.mainText
                                : AppColors.mainTextDark,
                          ),
                        ),
                        AppGap.v4,
                        Text(
                          '이 학생은 외출할 수 없어요',
                          style: AppTextStyles.caption1.copyWith(
                            color:
                                isLight ? AppColors.sub2 : AppColors.sub2Dark,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ToggleButton(
                        type: RoleEnum.admin,
                        value: isOutingBanned,
                        onChanged: (value) {
                          if (isOutingBanned) {
                            GomsDialog.bannedOutingRelease(
                              context: context,
                              title: '외출금지',
                              content: '\n이 학생을',
                              redContent: ' 외출금지 해제 ',
                              content2: '시키겠습니까?',
                              onConfirm: () {
                                setState(() {
                                  isOutingBanned = value;
                                  if (value) isCouncil = false;
                                });
                                widget.onRoleChanged(
                                  value
                                      ? StudentRole.outingBanned
                                      : StudentRole.student,
                                );
                              },
                            );
                          } else {
                            GomsDialog.bannedOuting(
                              context: context,
                              title: '외출금지',
                              content: '\n이 학생을',
                              redContent: ' 외출금지 ',
                              content2: '시키겠습니까?',
                              onConfirm: () {
                                setState(() {
                                  isOutingBanned = value;
                                  if (value) isCouncil = true;
                                });
                                widget.onRoleChanged(
                                  value
                                      ? StudentRole.outingBanned
                                      : StudentRole.student,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            AppGap.v12,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '학생회 권한 부여',
                        style: AppTextStyles.text1.copyWith(
                          color: isLight
                              ? AppColors.mainText
                              : AppColors.mainTextDark,
                        ),
                      ),
                      AppGap.v4,
                      Text(
                        '이 학생은 학생회 권한을 가지게 돼요',
                        style: AppTextStyles.caption1.copyWith(
                          color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ToggleButton(
                      type: RoleEnum.admin,
                      value: isCouncil,
                      onChanged: (value) {
                        setState(() {
                          isCouncil = value;
                          if (value) isOutingBanned = false;
                        });
                        widget.onRoleChanged(
                          value ? StudentRole.council : StudentRole.student,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
