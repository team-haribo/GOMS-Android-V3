import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/dialogs/forced_return_dialog.dart';

void main() async {
  runApp(ProviderScope(
      child: MaterialApp(
    home: SearchProfileList(
        name: '류수연', grade: 9, major: 'SW개발', role: RoleEnum.admin),
  )));
}

class SearchProfileList extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final RoleEnum role;

  const SearchProfileList({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      color: isLight ? AppColors.background : AppColors.backgroundDark,
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              radius: 24,
              child: AppIcons.profileCircle(),
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
                  color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    '$grade기 | $major',
                    style: AppTextStyles.text3.copyWith(
                      color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                    ),
                  ),
                  AppGap.h4,
                  SizedBox(
                    height: 8,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: isLight ? AppColors.button : AppColors.buttonDark,
                    ),
                  ),
                  AppGap.h4,
                  Text(
                    '10:31에 외출',
                    style: AppTextStyles.text3.copyWith(
                      color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          if (role == RoleEnum.admin) ...[
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: () {
                  forcedReturn(
                    context: context,
                    title: '외출 강제 복귀',
                    content: '\n외출자를 강제로 복귀시키겠습니까?',
                  );
                },
                icon: AppIcons.forceReturn(
                  color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
