import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/presentation/auth/auth_provider.dart';
import 'package:goms/widgets/common/base_scaffold.dart';

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

    String destination = RoutePath.onboarding;

    if (hasToken) {
      destination = RoutePath.home;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(destination);
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
