import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/buttons/qr_button.dart';
import 'package:goms/features/outing/presentation/widgets/late_profile_container.dart';
import 'package:goms/features/outing/presentation/widgets/profile_list_container.dart';
import 'package:goms/features/outing/presentation/widgets/user_manage_button.dart';
import 'package:goms/features/outing/presentation/widgets/view_more_users.dart';
import 'package:goms/features/late/presentation/models/late_rank_student_model.dart';
import 'package:goms/features/late/presentation/providers/late_rank_students_provider.dart';
import 'package:goms/features/outing/presentation/models/outing_student_model.dart';
import 'package:goms/features/outing/presentation/providers/current_outing_students_provider.dart';
import 'package:goms/features/outing/presentation/widgets/my_outing_status_card.dart';

class OutingWaitingScreen extends ConsumerStatefulWidget {
  const OutingWaitingScreen({
    super.key,
  });

  @override
  ConsumerState<OutingWaitingScreen> createState() =>
      _OutingWaitingScreenState();
}

class _OutingWaitingScreenState extends ConsumerState<OutingWaitingScreen> {
  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(currentOutingStudentsProvider.notifier).reload(),
      ref.read(lateRankStudentsProvider.notifier).reload(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider);
    final currentOutingStudents = ref.watch(currentOutingStudentsProvider);
    final lateRankStudents = ref.watch(lateRankStudentsProvider);
    final approvedStudentCount = switch (currentOutingStudents) {
      AsyncData(:final value) => value.length,
      _ => 0,
    };

    return BaseScaffold(
      showAppBar: true,
      showAppBarLogo: true,
      showAdminReportAction: true,
      role: role,
      body: RefreshIndicator(
        color: role == RoleEnum.admin ? AppColors.admin : AppColors.mainColor,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: MyOutingStatusCard(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '지각자 TOP 3',
                              style: AppTextStyles.title3.copyWith(
                                color: context.mainTextColor,
                              ),
                            ),
                            role == RoleEnum.admin
                                ? const ViewMoreUsers(
                                    path: RoutePath.studentCouncilLate,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        AppGap.v12,
                        _buildLateRankSection(lateRankStudents),
                        AppGap.v12,
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '외출 현황',
                            style: AppTextStyles.title3.copyWith(
                              color: context.mainTextColor,
                            ),
                          ),
                          AppGap.h8,
                          Text(
                            '$approvedStudentCount',
                            style: AppTextStyles.caption1
                                .copyWith(color: AppColors.mainColor),
                          ),
                          Text(
                            "명이 외출중",
                            style: AppTextStyles.caption1.copyWith(
                              color: context.isDarkMode
                                  ? AppColors.sub1Dark
                                  : AppColors.sub2,
                            ),
                          ),
                        ],
                      ),
                      const ViewMoreUsers(),
                    ],
                  ),
                  AppGap.v12,
                ],
              ),
            ),
            ..._buildOutingStudentSlivers(currentOutingStudents),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (role == RoleEnum.admin) ...[
            const UserManageButton(),
            AppGap.v12,
          ],
          QRButton(
            type: role == RoleEnum.admin ? RoleEnum.admin : RoleEnum.user,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOutingStudentSlivers(
    AsyncValue<List<OutingStudentModel>> currentOutingStudents,
  ) {
    return currentOutingStudents.when(
      skipLoadingOnRefresh: true,
      data: (students) {
        if (students.isEmpty) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    '현재 외출 중인 학생이 없어요.',
                    style: AppTextStyles.text2.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                ),
              ),
            ),
          ];
        }

        return [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final student = students[index];
                return Column(
                  children: [
                    ProfileListContainer(
                      name: student.name,
                      grade: student.grade,
                      major: student.department,
                      profileImageUrl: student.profileImageUrl,
                    ),
                    AppGap.v4,
                  ],
                );
              },
              childCount: students.length,
            ),
          ),
        ];
      },
      loading: () => [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
      error: (error, _) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    error is CurrentOutingStudentsException
                        ? error.message
                        : '외출 현황을 불러오지 못했어요.',
                    style: AppTextStyles.text2.copyWith(
                      color: context.sub2Color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppGap.v12,
                  TextButton(
                    onPressed: () {
                      ref.read(currentOutingStudentsProvider.notifier).reload();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLateRankSection(
    AsyncValue<List<LateRankStudentModel>> lateRankStudents,
  ) {
    return lateRankStudents.when(
      skipLoadingOnRefresh: true,
      data: (students) {
        final topStudents = students.take(3).toList();

        if (topStudents.isEmpty) {
          return _buildNoLateStudentsMessage();
        }

        return Row(
          children: [
            for (var i = 0; i < topStudents.length; i++) ...[
              Expanded(
                child: LateProfileContainer(
                  name: topStudents[i].name,
                  grade: topStudents[i].grade,
                  major: topStudents[i].department,
                  profileImageUrl: topStudents[i].profileImageUrl,
                ),
              ),
              if (i != topStudents.length - 1) AppGap.h12,
            ],
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error is LateRankStudentsException
                  ? error.message
                  : '지각 랭킹을 불러오지 못했어요.',
              style: AppTextStyles.text2.copyWith(
                color: context.sub2Color,
              ),
              textAlign: TextAlign.center,
            ),
            AppGap.v8,
            TextButton(
              onPressed: () {
                ref.read(lateRankStudentsProvider.notifier).reload();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLateStudentsMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcons.fire(
            width: 24,
            height: 24,
            color: context.isDarkMode ? AppColors.sub1Dark : AppColors.sub2,
          ),
          AppGap.v2,
          Text(
            '이번주 지각자가 없어요 축하해요!',
            style: AppTextStyles.text1.copyWith(
              fontSize: 15,
              color: context.isDarkMode ? AppColors.sub1Dark : AppColors.sub2,
            ),
          ),
        ],
      ),
    );
  }
}
