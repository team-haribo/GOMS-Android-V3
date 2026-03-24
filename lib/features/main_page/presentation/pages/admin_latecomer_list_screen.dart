import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/enums/student_role_enum.dart';
import 'package:goms/core/theme/config/light_theme.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/features/main_page/presentation/widgets/date_button.dart';
import 'package:goms/features/main_page/presentation/widgets/late_profile_list_container.dart';
import 'package:goms/features/main_page/presentation/widgets/search_profile_container_model.dart';

final roleProvider = Provider<RoleEnum>((ref)=> throw UnimplementedError());

void main() async {
  runApp(
    ProviderScope(
      overrides: [
        roleProvider.overrideWithValue(RoleEnum.admin),
      ],
      child: MaterialApp(
        theme: LightTheme.theme,
        themeMode: ThemeMode.light,
        home: const AdminLatecomerListScreen(),
      ),
    ),
  );
}

class AdminLatecomerListScreen extends ConsumerStatefulWidget{

  const AdminLatecomerListScreen({
    super.key,
  });

  @override
  ConsumerState<AdminLatecomerListScreen> createState() => _OutingStateScreenState();
}

class _OutingStateScreenState extends ConsumerState<AdminLatecomerListScreen> {
  bool isOutingDay = true;

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
    final role = ref.watch(roleProvider);

    return BaseScaffold(
      showAppBar: true,
      role: role,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '지각자 명단',
              style: AppTextStyles.title1.copyWith(
                color: isLight ? AppColors.mainText : AppColors.mainTextDark,
              ),
          ),
          AppGap.v24,
          Row(
            children: [
              Text(
                '2024년 7월 10일 (수)',
                style: AppTextStyles.title3.copyWith(color: AppColors.mainText),
              ),
              const Spacer(),
              const DateButton(),
            ],
          ),
          AppGap.v4,
          Expanded(
            child: ListView.separated(
              itemCount: outingMembers.length,
              itemBuilder: (context, index) {
                final member = outingMembers[index];
                return LateProfileListContainer(
                  name: member.name,
                  grade: member.grade,
                  major: member.major,
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
      ),
    );
  }
}
