import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/constants/spacing_constants.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      showAppBar: false,
      body: Column(
        children: [
          const Spacer(flex: 2),
          // 로고
          AppIcons.gomsLogo(width: 80, height: 80),
          const SizedBox(height: SpacingConstants.v12),
          // 타이틀
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.title2.withColor(
                isDark ? AppColors.mainTextDark : AppColors.mainText,
              ),
              children: [
                TextSpan(
                  text: '월수 외출체',
                  style: AppTextStyles.title2.withColor(AppColors.mainColor),
                ),
                const TextSpan(text: ' 관리 서비스'),
              ],
            ),
          ),
          const SizedBox(height: SpacingConstants.v16),
          // 설명
          Column(
            children: [
              Text(
                'GOMS로 간편하게',
                textAlign: TextAlign.center,
                style: AppTextStyles.text2.withColor(
                  isDark ? AppColors.sub1Dark : AppColors.sub2,
                ),
              ),
              Text(
                '월수 외출체를 이용해 보세요!',
                textAlign: TextAlign.center,
                style: AppTextStyles.text2.withColor(
                  isDark ? AppColors.sub1Dark : AppColors.sub2,
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
          // 로그인 버튼
          ConfirmButton(
            text: '로그인',
            onPressed: () => context.push(RoutePath.login),
          ),
          const SizedBox(height: SpacingConstants.v16),
          // 구분선
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: isDark ? AppColors.sub2Dark : AppColors.button,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.h4),
                child: Text(
                  'GOMS가 처음이신가요?',
                  style: AppTextStyles.caption3.withColor(
                    isDark ? AppColors.sub2Dark : AppColors.button,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: isDark ? AppColors.sub2Dark : AppColors.button,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingConstants.v12),
          // 회원가입 하기
          GestureDetector(
            onTap: () {
              // TODO: 회원가입 페이지로 이동
              // context.go(RoutePath.signup);
            },
            child: Text(
              '회원가입 하기',
              style: AppTextStyles.text1.withColor(AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }
}
