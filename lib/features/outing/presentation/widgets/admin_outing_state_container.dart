import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/avatars/profile_avatar.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/outing/presentation/widgets/admin_bottom_sheet.dart';

final _adminOutingStudentRoleProvider =
    StateProvider.autoDispose.family<StudentRole, (Object, StudentRole)>(
      (ref, args) => args.$2,
    );

class AdminOutingStateContainer extends ConsumerStatefulWidget {
  final int memberId;
  final String name;
  final int grade;
  final String major;
  final StudentRole studentRole;
  final String profileImageUrl;

  const AdminOutingStateContainer({
    super.key,
    required this.memberId,
    required this.name,
    required this.grade,
    required this.major,
    required this.studentRole,
    required this.profileImageUrl,
  });

  @override
  ConsumerState<AdminOutingStateContainer> createState() =>
      _AdminOutingStateContainerState();
}

class _AdminOutingStateContainerState
    extends ConsumerState<AdminOutingStateContainer> {
  late final Object _providerIdentity;

  (Object, StudentRole) get _providerKey =>
      (_providerIdentity, widget.studentRole);

  @override
  void initState() {
    super.initState();
    _providerIdentity = Object();
  }

  @override
  Widget build(BuildContext context) {
    final studentRole = ref.watch(_adminOutingStudentRoleProvider(_providerKey));

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
                  builder: (context) => AdminBottomSheet(
                    memberId: widget.memberId,
                    studentRole: studentRole,
                    onRoleChanged: (newRole) {
                      ref
                          .read(
                            _adminOutingStudentRoleProvider(
                              _providerKey,
                            ).notifier,
                          )
                          .state = newRole;
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
