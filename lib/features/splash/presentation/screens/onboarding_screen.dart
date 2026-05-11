import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';

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
                  text: '외출제',
                  style: AppTextStyles.title2.withColor(AppColors.mainColor),
                ),
                const TextSpan(text: ' 관리 서비스'),
              ],
            ),
          ),
          AppGap.v24,
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
                '외출제를 이용해 보세요!',
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
                  color:
                      context.isDarkMode ? context.sub2Color : AppColors.button,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                ),
                child: Text(
                  'GOMS가 처음이라면?',
                  style: AppTextStyles.caption3.withColor(
                    context.sub1Color,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color:
                      context.isDarkMode ? context.sub2Color : AppColors.button,
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
