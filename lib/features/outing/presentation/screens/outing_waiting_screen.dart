import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/utils/student_info_formatter.dart';
import 'package:goms/features/late/presentation/models/late_rank_student_model.dart';
import 'package:goms/features/late/presentation/providers/late_rank_students_provider.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_status.dart';
import 'package:goms/features/outing/presentation/providers/current_outing_students_provider.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';
import 'package:goms/features/outing/presentation/providers/time_provider.dart';
import 'package:goms/features/profile/presentation/viewmodels/settings_viewmodel.dart';

// ui
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/buttons/qr_button.dart';
import 'package:goms/features/outing/presentation/widgets/user_manage_button.dart';

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
      ref.read(myOutingStatusProvider.notifier).reload(),
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
    AsyncValue<List<OutingStudentEntity>> currentOutingStudents,
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

// ---------------------------------------------------------------------------
// LateProfileContainer (moved from widgets/late_profile_container.dart)
// ---------------------------------------------------------------------------

class LateProfileContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const LateProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 101,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s12,
          horizontal: AppSpacing.s20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileAvatar(
              radius: 28,
              imageUrl: profileImageUrl,
              backgroundColor: context.backgroundColor,
            ),

            AppGap.v8, // 12 -> 8
            Text(
              name,
              style: AppTextStyles.title1.copyWith(
                color: context.sub1Color,
                fontSize: 16,
              ),
            ),
            AppGap.v2, // 4 -> 2
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                StudentInfoFormatter.formatCohortDepartment(
                  grade: grade,
                  department: major,
                ),
                style:
                    AppTextStyles.caption1.copyWith(color: context.sub2Color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ProfileListContainer (moved from widgets/profile_list_container.dart)
// ---------------------------------------------------------------------------

class ProfileListContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const ProfileListContainer({
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
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ProfileAvatar(
                radius: 14,
                imageUrl: profileImageUrl,
                backgroundColor: context.surfaceColor,
              ),
              AppGap.h8,
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: context.sub1Color,
                ),
              ),
            ],
          ),
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
    );
  }
}

// ---------------------------------------------------------------------------
// ViewMoreUsers (moved from widgets/view_more_users.dart)
// ---------------------------------------------------------------------------

class ViewMoreUsers extends StatelessWidget {
  const ViewMoreUsers({
    super.key,
    this.path = RoutePath.outingState,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 24),
      child: ElevatedButton(
        onPressed: () {
          context.push(path);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 24),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: context.surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: Text(
          "더보기",
          style: AppTextStyles.caption2.copyWith(
            fontWeight: FontWeight.w300,
            color: context.isLightMode ? context.sub2Color : context.sub1Color,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TimeDisplay (moved from widgets/time_display.dart)
// ---------------------------------------------------------------------------

class TimeDisplay extends ConsumerWidget {
  const TimeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(currentTimeProvider).value ?? DateTime.now();
    final ampm = DateFormat('a', 'en_US').format(now);
    final time = DateFormat('h : mm : ss').format(now);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$ampm ',
            style:
                AppTextStyles.dateTimeAmPm.copyWith(color: context.sub2Color),
          ),
          TextSpan(
            text: time,
            style: AppTextStyles.dateTime.copyWith(color: context.sub2Color),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ProfileContainer (moved from widgets/profile_container.dart)
// ---------------------------------------------------------------------------

class ProfileContainer extends ConsumerWidget {
  final String name;
  final int grade;
  final String major;
  final int lateCount;
  final OutingStatus status;
  final String profileImageUrl;
  final bool showProfileImageErrorMessage;
  final String profileImageErrorMessage;
  final bool showLateCount;
  final bool showInfoBelowName;

  const ProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.lateCount,
    required this.status,
    required this.profileImageUrl,
    this.showProfileImageErrorMessage = false,
    this.profileImageErrorMessage = '프로필 이미지를 불러오지 못했어요.',
    this.showLateCount = true,
    this.showInfoBelowName = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showClock = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value.showClock,
      _ => false,
    };
    final height = showClock
        ? context.responsive(compact: 88, normal: 96, tablet: 104)
        : context.responsive(compact: 76, normal: 84, tablet: 92);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.responsive(compact: 12, normal: 16)),
        child: Row(
          children: [
            if (!showClock) ...[
              ProfileAvatar(
                radius: context.responsive(compact: 22, normal: 26, tablet: 28),
                imageUrl: profileImageUrl,
                backgroundColor: context.backgroundColor,
                showErrorMessage: showProfileImageErrorMessage,
                errorMessage: profileImageErrorMessage,
              ),
              AppGap.h12,
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIdentity(context, showClock),
                  if (showLateCount)
                    Text(
                      '지각 횟수: $lateCount회',
                      style: AppTextStyles.text3.copyWith(
                        color: context.sub1Color,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    status.statusText,
                    style: AppTextStyles.text1.copyWith(
                      color: status.statusColor,
                    ),
                  ),
                  if (showClock) ...[
                    AppGap.v2,
                    const Flexible(
                      child: TimeDisplay(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentity(BuildContext context, bool showClock) {
    if (showClock && !showInfoBelowName) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          _buildNameText(context),
          AppGap.h8,
          _buildInfoText(context),
        ],
      );
    }

    if (showInfoBelowName) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameText(context),
          AppGap.v2,
          _buildInfoText(context),
        ],
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          _buildNameText(context),
          AppGap.h8,
          _buildInfoText(context),
        ],
      ),
    );
  }

  Widget _buildNameText(BuildContext context) {
    return Text(
      name,
      style: AppTextStyles.title3.copyWith(
        color: context.mainTextColor,
      ),
    );
  }

  Widget _buildInfoText(BuildContext context) {
    return Text(
      StudentInfoFormatter.formatCohortDepartment(
        grade: grade,
        department: major,
      ),
      style: AppTextStyles.text3.copyWith(
        color: context.sub2Color,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MyOutingStatusCard (moved from widgets/my_outing_status_card.dart)
// ---------------------------------------------------------------------------

class MyOutingStatusCard extends ConsumerWidget {
  const MyOutingStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final myOutingStatus = ref.watch(myOutingStatusProvider);

    return myOutingStatus.when(
      skipLoadingOnRefresh: true,
      data: (value) {
        print('===== 외출 상태 확인 =====');
        print('name = ${value.name}');
        print('status = ${value.status}');
        print(value);

        return ProfileContainer(
          name: value.name,
          grade: value.grade,
          major: value.department,
          lateCount: value.lateCount,
          showLateCount: role != RoleEnum.admin,
          showInfoBelowName: role == RoleEnum.admin,
          profileImageUrl: value.profileImageUrl,
          showProfileImageErrorMessage: true,
          profileImageErrorMessage: '프로필 이미지를 불러오지 못했어요.',
          status: role == RoleEnum.admin
              ? OutingStatus.admin
              : OutingStatus.fromServer(value.status),
        );
      },
      loading: () => ProfileContainer(
        name: '불러오는 중',
        grade: 0,
        major: '',
        lateCount: 0,
        showLateCount: role != RoleEnum.admin,
        showInfoBelowName: role == RoleEnum.admin,
        profileImageUrl: '',
        status:
            role == RoleEnum.admin ? OutingStatus.admin : OutingStatus.waiting,
      ),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileContainer(
            name: '정보 없음',
            grade: 0,
            major: '',
            lateCount: 0,
            showLateCount: role != RoleEnum.admin,
            showInfoBelowName: role == RoleEnum.admin,
            profileImageUrl: '',
            status: role == RoleEnum.admin
                ? OutingStatus.admin
                : OutingStatus.waiting,
          ),
          AppGap.v12,
          Text(
            error is MyOutingStatusException
                ? error.message
                : '내 외출 현황을 불러오지 못했어요.',
            style: AppTextStyles.text2.copyWith(
              color: context.sub2Color,
            ),
          ),
          AppGap.v8,
          TextButton(
            onPressed: () {
              ref.read(myOutingStatusProvider.notifier).reload();
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
