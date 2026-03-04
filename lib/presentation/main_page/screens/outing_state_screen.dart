import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/config/dark_theme.dart';
import 'package:project_setting/core/theme/config/light_theme.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/domain/enum/role_enum.dart';
import 'package:project_setting/presentation/main_page/widget/search_profile_list.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/qr_button.dart';
import 'package:project_setting/widgets/common/text_fields/search_student.dart';
import 'package:project_setting/presentation/main_page/widget/search_profile_container_model.dart';

void main() async {
  runApp(
    MaterialApp(
      home: const OutingStateScreen(),
      themeMode: ThemeMode.dark,
      theme: DarkTheme.theme,
    ),
  );
}

class OutingStateScreen extends StatefulWidget {
  const OutingStateScreen({super.key});

  @override
  State<OutingStateScreen> createState() => _OutingStateScreenState();
}

class _OutingStateScreenState extends State<OutingStateScreen> {
  bool isOutingDay = true;

  String searchText = "";

  List<SearchProfileContainerModel> outingMembers = [
    SearchProfileContainerModel(name: '류수연', grade: 9, major: 'SW개발'),
    SearchProfileContainerModel(name: '이주언', grade: 8, major: 'AI'),
    SearchProfileContainerModel(name: '김민솔', grade: 8, major: 'AI'),
    SearchProfileContainerModel(name: '류수연', grade: 9, major: 'SW개발'),
    SearchProfileContainerModel(name: '이주언', grade: 8, major: 'AI'),
    SearchProfileContainerModel(name: '김민솔', grade: 8, major: 'AI'),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final filteredList = searchText.isEmpty
        ? outingMembers
        : outingMembers.where((member) {
            return member.name.toLowerCase().contains(searchText.toLowerCase());
          }).toList();

    return BaseScaffold(
      showAppBar: true,
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGap.v24,
            Text(
              '외출 현황',
              style: AppTextStyles.title1.copyWith(
                  color: isLight ? AppColors.mainText : AppColors.mainTextDark),
            ),
            AppGap.v24,
            Align(
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
                ),
                child: SearchStudentField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
            ),
            if (!isOutingDay)
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    AppGap.v190,
                    AppIcons.coffee(),
                    AppGap.v8,
                    Text(
                      '오늘은 외출하는 날이 아니에요!',
                      style: AppTextStyles.title1
                          .copyWith(fontSize: 14, color: AppColors.sub2),
                    ),
                  ],
                ),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '검색결과',
                  style: AppTextStyles.title3.copyWith(
                      color: isLight
                          ? AppColors.mainText
                          : AppColors.mainTextDark),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final member = filteredList[index];
                    return SearchProfileList(
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
            ]
          ],
        ),
        Positioned(
          left: 297,
          top: 660,
          child: QRButton(
            type: RoleEnum.user,
            onPressed: () {},
          ),
        ),
      ]),
    );
  }
}
