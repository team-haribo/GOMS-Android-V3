import 'package:flutter/material.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/buttons/qr_button.dart';
import 'package:goms/features/main_page/presentation/widgets/late_profile_container.dart';
import 'package:goms/features/main_page/presentation/widgets/outing_status.dart';
import 'package:goms/features/main_page/presentation/widgets/profile_container.dart';
import 'package:goms/features/main_page/presentation/widgets/profile_list_container.dart';
import 'package:goms/features/main_page/presentation/widgets/view_more_users.dart';

class OutingWaitingScreen extends StatelessWidget {
  final int approvedStudentCount;
  final bool hasLateStudents;

  const OutingWaitingScreen({
    super.key,
    required this.approvedStudentCount,
    required this.hasLateStudents,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showAppBar: true,
      showAppBarLogo: true,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 24),
                  child: ProfileContainer(
                    name: '류수연',
                    grade: 9,
                    major: 'SW개발',
                    lateCount: 0,
                    status: OutingStatus.waiting,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '지각자 TOP 3',
                        style: AppTextStyles.title3.copyWith(
                          color: context.mainTextColor,
                        ),
                      ),
                      AppGap.v12,
                      hasLateStudents
                          ? const Row(
                              children: [
                                Expanded(
                                  child: LateProfileContainer(
                                    name: '류수연',
                                    grade: 9,
                                    major: 'SW개발',
                                  ),
                                ),
                                AppGap.h12,
                                Expanded(
                                  child: LateProfileContainer(
                                    name: '류수연',
                                    grade: 9,
                                    major: 'SW개발',
                                  ),
                                ),
                                AppGap.h12,
                                Expanded(
                                  child: LateProfileContainer(
                                    name: '류수연',
                                    grade: 9,
                                    major: 'SW개발',
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppIcons.fire(
                                    width: 24,
                                    height: 24,
                                    color: context.sub1Color,
                                  ),
                                  AppGap.v2,
                                  Text(
                                    '이번주 지각자가 없어요 축하해요!',
                                    style: AppTextStyles.text1.copyWith(
                                      fontSize: 15,
                                      color: context.sub1Color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.mainColor,
                          ),
                        ),
                        Text(
                          '명이 외출중',
                          style: AppTextStyles.caption1.copyWith(
                            color: context.sub1Color,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return const Column(
                  children: [
                    ProfileListContainer(
                      name: '류수연',
                      grade: 9,
                      major: 'SW개발',
                    ),
                    AppGap.v4,
                  ],
                );
              },
              childCount: approvedStudentCount,
            ),
          ),
        ],
      ),
      floatingActionButton: const QRButton(type: RoleEnum.user),
    );
  }
}
