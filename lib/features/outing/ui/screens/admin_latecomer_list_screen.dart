import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/features/outing/ui/widgets/date_button.dart';
import 'package:goms/features/outing/ui/widgets/late_profile_list_container.dart';
import 'package:goms/features/late/ui/providers/student_council_late_students_provider.dart';

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
