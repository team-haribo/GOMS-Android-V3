import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/config/light_theme.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/domain/enum/role_enum.dart';
import 'package:project_setting/presentation/main_page/widget/late_profile_container.dart';
import 'package:project_setting/presentation/main_page/widget/outing_status.dart';
import 'package:project_setting/presentation/main_page/widget/profile_container.dart';
import 'package:project_setting/presentation/main_page/widget/profile_list_container.dart';
import 'package:project_setting/presentation/main_page/widget/view_more_users.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/qr_button.dart';
import 'package:project_setting/widgets/goms_bottom_navigation.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: LightTheme.theme,
      themeMode: ThemeMode.light,
      home: const OutingWaitingScreen(approvedStudentCount: 66),
    ),
  );
}

class OutingWaitingScreen extends StatefulWidget {
  final int approvedStudentCount;

  const OutingWaitingScreen({super.key, required this.approvedStudentCount});

  @override
  State<OutingWaitingScreen> createState() => _OutingWaitingScreenState();
}

class _OutingWaitingScreenState extends State<OutingWaitingScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool hasLateStudents = false; // 여기서 true, false 조절

    return BaseScaffold(
      showAppBar: true,
      showAppBarLogo: true,
      body: SingleChildScrollView(
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
                onTime: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '지각자 TOP 3',
                    style: AppTextStyles.title3
                        .copyWith(color: AppColors.mainText),
                  ),
                  AppGap.v12,
                  if (hasLateStudents)
                    const Row(
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
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcons.fire(
                          width: 24,
                          height: 24,
                          color: isDark ? AppColors.sub2 : AppColors.sub1Dark,
                        ),
                        AppGap.v2,
                        Text(
                          '이번주 지각자가 없어요 축하해요!',
                          style: AppTextStyles.text1.copyWith(
                            fontSize: 15,
                            color: isDark ? AppColors.sub2 : AppColors.sub1Dark,
                          ),
                        ),
                      ],
                    ),
                  AppGap.v24,
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
                      style: AppTextStyles.title3
                          .copyWith(color: AppColors.mainText),
                    ),
                    AppGap.h8,
                    Text(
                      '${widget.approvedStudentCount}',
                      style: AppTextStyles.caption1
                          .copyWith(color: AppColors.mainColor),
                    ),
                    Text(
                      "명이 외출중",
                      style: AppTextStyles.caption1
                          .copyWith(color: AppColors.sub2),
                    ),
                  ],
                ),
                const ViewMoreUsers(),
              ],
            ),
            AppGap.v12,
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.approvedStudentCount,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
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
            ),
          ],
        ),
      ),
      floatingActionButton: QRButton(
        type: RoleEnum.user,
        onPressed: () {},
      ),
      bottomNavigationBar: GomsBottomNavigation(
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}
