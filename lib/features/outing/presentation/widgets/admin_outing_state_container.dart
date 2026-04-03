import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/outing/presentation/widgets/user_role_bottomsheet.dart';

class AdminOutingStateContainer extends ConsumerStatefulWidget {
  final int memberId;
  final String name;
  final int grade;
  final String major;
  final StudentRole studentRole;

  const AdminOutingStateContainer({
    super.key,
    required this.memberId,
    required this.name,
    required this.grade,
    required this.major,
    required this.studentRole,
  });

  @override
  ConsumerState<AdminOutingStateContainer> createState() =>
      _AdminOutingStateContainerState();
}

class _AdminOutingStateContainerState
    extends ConsumerState<AdminOutingStateContainer> {
  late StudentRole _studentRole;

  @override
  void initState() {
    super.initState();
    _studentRole = widget.studentRole;
  }

  @override
  Widget build(BuildContext context) {
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
                  color: _studentRole == StudentRole.council
                      ? AppColors.admin
                      : _studentRole == StudentRole.outingBanned
                          ? AppColors.negative
                          : Colors.transparent,
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: _studentRole == StudentRole.outingBanned ||
                        _studentRole == StudentRole.council
                    ? 22
                    : 24,
                child: AppIcons.profileCircle(),
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
                  color: _studentRole == StudentRole.outingBanned
                      ? AppColors.negative
                      : _studentRole == StudentRole.council
                          ? AppColors.admin
                          : context.sub1Color,
                ),
              ),
              AppGap.h4,
              Text(
                '${widget.grade}학년 | ${widget.major}',
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
                  builder: (context) => FractionallySizedBox(
                    heightFactor: _studentRole == StudentRole.student
                        ? 0.42
                        : _studentRole == StudentRole.outingBanned
                            ? 0.33
                            : 0.24,
                    child: UserRoleBottomSheet(
                      memberId: widget.memberId,
                      studentRole: _studentRole,
                      onRoleChanged: (newRole) {
                        setState(() {
                          _studentRole = newRole;
                        });
                        Navigator.pop(context);
                      },
                    ),
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
