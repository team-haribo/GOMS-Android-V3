import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/features/late/presentation/providers/student_council_late_students_provider.dart';
//ui
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/utils/student_info_formatter.dart';

class AdminLatecomerListScreen extends ConsumerStatefulWidget {
  const AdminLatecomerListScreen({
    super.key,
  });

  @override
  ConsumerState<AdminLatecomerListScreen> createState() =>
      _AdminLatecomerListScreenState();
}

class _AdminLatecomerListScreenState
    extends ConsumerState<AdminLatecomerListScreen> {
  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  Future<void> _pickDate() async {
    final initialDate =
        ref.read(studentCouncilLateDateProvider) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      ref.read(studentCouncilLateDateProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider);
    final selectedDate = ref.watch(studentCouncilLateDateProvider);
    final lateStudents = ref.watch(studentCouncilLateStudentsProvider);
    final displayedDate = selectedDate ?? DateTime.now();

    return BaseScaffold(
      showAppBar: true,
      role: role,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '지각자 명단',
            style: AppTextStyles.title1.copyWith(
              color: context.mainTextColor,
            ),
          ),
          AppGap.v24,
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatDate(displayedDate),
                  style: AppTextStyles.title3.copyWith(
                    color: context.mainTextColor,
                  ),
                ),
              ),
              DateButton(
                label: '날짜 선택',
                onPressed: _pickDate,
              ),
            ],
          ),
          AppGap.v4,
          Expanded(
            child: RefreshIndicator(
              color: AppColors.admin,
              onRefresh: () {
                return ref
                    .read(studentCouncilLateStudentsProvider.notifier)
                    .reload();
              },
              child: lateStudents.when(
                data: (students) {
                  if (students.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 280,
                          child: Center(
                            child: Text(
                              '지각자가 없어요.',
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
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final member = students[index];
                      return LateProfileListContainer(
                        name: member.name,
                        grade: member.grade,
                        major: member.department,
                        profileImageUrl: member.profileImageUrl,
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
                              error is StudentCouncilLateStudentsException
                                  ? error.message
                                  : '지각자 명단을 불러오지 못했어요.',
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
                                      studentCouncilLateStudentsProvider
                                          .notifier,
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
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일 (${_weekdays[date.weekday - 1]})';
  }
}

// ---------------------------------------------------------------------------
// DateButton (moved from widgets/date_button.dart)
// ---------------------------------------------------------------------------

class DateButton extends StatelessWidget {
  const DateButton({
    super.key,
    this.label = '날짜',
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: AppTextStyles.text2.copyWith(
          color: AppColors.admin,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LateProfileListContainer (moved from widgets/late_profile_list_container.dart)
// ---------------------------------------------------------------------------

class LateProfileListContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const LateProfileListContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.profileImageUrl,
  });

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
            child: ProfileAvatar(
              radius: 24,
              imageUrl: profileImageUrl,
              backgroundColor: context.surfaceColor,
            ),
          ),
          AppGap.v4,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: context.sub1Color,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    StudentInfoFormatter.formatCohortDepartment(
                      grade: grade,
                      department: major,
                    ),
                    style: AppTextStyles.caption2.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
