import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/utils/settings_storage.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/buttons/qr_button.dart';
import 'package:goms/core/widgets/common/text_fields/search_student.dart';
import 'package:goms/features/member/presentation/providers/student_council_members_provider.dart';
import 'package:goms/features/outing/presentation/widgets/admin_outing_state_container.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminOutingStateScreen extends ConsumerStatefulWidget {
  const AdminOutingStateScreen({
    super.key,
  });

  @override
  ConsumerState<AdminOutingStateScreen> createState() =>
      _AdminOutingStateScreen();
}

class _AdminOutingStateScreen extends ConsumerState<AdminOutingStateScreen> {
  bool isOutingDay = true;

  @override
  void initState() {
    super.initState();
    _checkCameraLaunch();
  }

  Future<void> _checkCameraLaunch() async {
    final cameraLaunch = await SettingsStorage.getCameraLaunch();
    if (!cameraLaunch) return;
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted && mounted) {
      context.push(RoutePath.qrIssue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchText = ref.watch(studentCouncilMemberSearchProvider);
    final membersAsync = ref.watch(studentCouncilMembersProvider);
    final role = ref.watch(roleProvider);

    return BaseScaffold(
      showAppBar: true,
      role: role,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '학생관리',
                  style: AppTextStyles.title1.copyWith(
                    color: context.mainTextColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.push(RoutePath.studentCouncilLate),
                child: const Text('지각자 명단'),
              ),
            ],
          ),
          AppGap.v24,
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.surfaceColor,
              ),
              child: SearchStudentField(
                onChanged: (value) {
                  ref.read(studentCouncilMemberSearchProvider.notifier).state =
                      value;
                },
              ),
            ),
          ),
          if (!isOutingDay)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.coffee(),
                    AppGap.v8,
                    Text(
                      '오늘은 외출하는 날이 아니에요!',
                      style: AppTextStyles.title1
                          .copyWith(fontSize: 14, color: AppColors.sub2),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            AppGap.v12,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '검색결과',
                style: AppTextStyles.title3.copyWith(
                  color: context.mainTextColor,
                ),
              ),
            ),
            AppGap.v12,
            Expanded(
              child: membersAsync.when(
                data: (members) {
                  final filteredMembers = searchText.trim().isEmpty
                      ? members
                      : members
                          .where(
                            (member) => member.name
                                .toLowerCase()
                                .contains(searchText.toLowerCase()),
                          )
                          .toList();

                  if (filteredMembers.isEmpty) {
                    return Center(
                      child: Text(
                        searchText.trim().isEmpty
                            ? '조회된 학생이 없어요.'
                            : '검색 결과가 없어요.',
                        style: AppTextStyles.text2.copyWith(
                          color: context.sub2Color,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
                      return AdminOutingStateContainer(
                        memberId: member.memberId,
                        name: member.name,
                        grade: member.grade,
                        major: member.department,
                        studentRole: member.studentRole,
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error is StudentCouncilMembersException
                            ? error.message
                            : '학생 목록을 불러오지 못했어요.',
                        style: AppTextStyles.text2.copyWith(
                          color: context.sub2Color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppGap.v12,
                      TextButton(
                        onPressed: () {
                          ref
                              .read(studentCouncilMembersProvider.notifier)
                              .reload();
                        },
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: QRButton(type: role),
    );
  }
}
