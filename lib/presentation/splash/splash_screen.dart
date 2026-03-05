import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/presentation/auth/auth_provider.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 스플래시 화면 최소 표시 시간
    await Future.delayed(const Duration(seconds: 2));

    // 토큰 확인
    final hasToken = await ref.read(authProvider.notifier).checkToken();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasToken) {
        // 토큰이 있으면 홈으로 이동
        context.go(RoutePath.home);
      } else {
        // 토큰이 없으면 온보딩으로 이동
        context.go(RoutePath.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showAppBar: false,
      body: Center(child: AppIcons.gomsLogo(width: 80, height: 80)),
    );
  }
}
