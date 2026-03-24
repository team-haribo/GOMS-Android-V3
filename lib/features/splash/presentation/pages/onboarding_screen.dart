import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/base_scaffold.dart';
import 'package:goms/core/widgets/common/buttons/confirm_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showAppBar: false,
      body: Column(
        children: [
          const Spacer(flex: 2),
          // 로고
          AppIcons.gomsLogo(width: 80, height: 80),
          AppGap.v12,
          // 타이틀
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.title2.withColor(
                context.mainTextColor,
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
          AppGap.v16,
          // 설명
          Column(
            children: [
              Text(
                'GOMS로 간편하게',
                textAlign: TextAlign.center,
                style: AppTextStyles.text2.withColor(
                  context.sub1Color,
                ),
              ),
              Text(
                '월수 외출체를 이용해 보세요!',
                textAlign: TextAlign.center,
                style: AppTextStyles.text2.withColor(
                  context.sub1Color,
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
          AppGap.v16,
          // 구분선
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: context.isDarkMode ? context.sub2Color : AppColors.button,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                ),
                child: Text(
                  'GOMS가 처음이신가요?',
                  style: AppTextStyles.caption3.withColor(
                    context.isDarkMode ? context.sub2Color : AppColors.button,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: context.isDarkMode ? context.sub2Color : AppColors.button,
                ),
              ),
            ],
          ),
          AppGap.v12,
          // 회원가입 하기
          GestureDetector(
            onTap: () {
              context.push(RoutePath.signUp);
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

