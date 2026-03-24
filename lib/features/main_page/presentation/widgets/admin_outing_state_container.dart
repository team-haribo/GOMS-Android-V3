import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/enums/student_role_enum.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/main_page/presentation/widgets/user_role_bottomsheet.dart';

final roleProvider = Provider<RoleEnum>((ref) => throw UnimplementedError());

class AdminOutingStateContainer extends ConsumerStatefulWidget {
  final String name;
  final int grade;
  final String major;
  final StudentRole studentRole;

  const AdminOutingStateContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.studentRole,
  });

  @override
  ConsumerState<AdminOutingStateContainer> createState() =>
      _AdminOutingStateContainerState();
}

class _AdminOutingStateContainerState extends ConsumerState<AdminOutingStateContainer> {
  late StudentRole _studentRole;

  @override
  void initState() {
    super.initState();
    _studentRole = widget.studentRole;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final role = ref.watch(roleProvider);

    return Container(
      color: isLight ? AppColors.background : AppColors.backgroundDark,
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
                          : (isLight ? AppColors.sub1 : AppColors.sub1Dark),
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    '${widget.grade}기 | ${widget.major}',
                    style: AppTextStyles.caption2.copyWith(
                      color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                    ),
                  ),
                ],
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
                  backgroundColor:
                      isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
                  builder: (context) => FractionallySizedBox(
                    heightFactor: _studentRole == StudentRole.student
                        ? 0.42
                        : _studentRole == StudentRole.outingBanned
                            ? 0.33
                            : 0.24,
                    child: UserRoleBottomSheet(
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
                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
