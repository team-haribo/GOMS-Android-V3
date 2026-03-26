import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/enums/student_role_enum.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/buttons/qr_button.dart';
import 'package:goms/core/widgets/common/text_fields/search_student.dart';
import 'package:goms/features/main_page/presentation/widgets/admin_outing_state_container.dart';
import 'package:goms/features/main_page/presentation/widgets/filter_button.dart';
import 'package:goms/features/main_page/presentation/widgets/search_profile_container_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/utils/settings_storage.dart';

final roleProvider = Provider<RoleEnum>((ref) => throw UnimplementedError());
final searchTextProvider = StateProvider<String>((ref) => '');

class AdminOutingStateScreen extends ConsumerStatefulWidget {
  const AdminOutingStateScreen({
    super.key,
  });

  @override
  ConsumerState<AdminOutingStateScreen> createState() => _AdminOutingStateScreen();
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
      context.push(RoutePath.qr);
    }
  }

  List<SearchProfileContainerModel> outingMembers = [
    const SearchProfileContainerModel(name: '류수연', grade: 9, major: 'SW개발', studentRole: StudentRole.council),
    const SearchProfileContainerModel(name: '이주언', grade: 8, major: 'AI', studentRole: StudentRole.outingBanned),
    const SearchProfileContainerModel(name: '김민솔', grade: 8, major: 'AI', studentRole: StudentRole.student),
    const SearchProfileContainerModel(name: '류수연', grade: 9, major: 'SW개발',studentRole: StudentRole.outingBanned),
    const SearchProfileContainerModel(name: '이주언', grade: 8, major: 'AI', studentRole: StudentRole.outingBanned),
    const SearchProfileContainerModel(name: '김민솔', grade: 8, major: 'AI', studentRole: StudentRole.outingBanned),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final searchText = ref.watch(searchTextProvider);

    final role = ref.watch(roleProvider);

    final filteredList = searchText.isEmpty
        ? outingMembers
        : outingMembers.where((member) {
      return member.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return BaseScaffold(
      showAppBar: true,
      role: role,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '학생관리',
              style: AppTextStyles.title1.copyWith(
                color: isLight ? AppColors.mainText : AppColors.mainTextDark,
              ),
            ),
          ),
          AppGap.v24,
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
              ),
              child: SearchStudentField(
                onChanged: (value) {
                  ref.read(searchTextProvider.notifier).state = value;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '검색결과',
                  style: AppTextStyles.title3.copyWith(
                    color: isLight
                        ? AppColors.mainText
                        : AppColors.mainTextDark,
                  ),
                ),
                const FilterButton(),
              ],
            ),
            AppGap.v12,
            Expanded(
              child: ListView.separated(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final member = filteredList[index];
                  return AdminOutingStateContainer(
                    name: member.name,
                    grade: member.grade,
                    major: member.major,
                    studentRole: member.studentRole,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 1,
                    color: isLight ? AppColors.button : AppColors.buttonDark,
                  );
                },
              ),
            ),
          ],
        ],
      ),
      floatingActionButton:
          QRButton(
              type: role == RoleEnum.admin
                  ? RoleEnum.admin
                  : RoleEnum.user,),
    );
  }
}
