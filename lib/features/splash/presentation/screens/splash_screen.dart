import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/utils/camera_launch_destination_resolver.dart';
import 'package:goms/core/utils/settings_storage.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/features/auth/session/presentation/providers/session_provider.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';

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

    debugPrint('SplashScreen: starting auth check');

    final hasToken = await ref.read(authProvider.notifier).checkToken();

    if (!mounted) return;

    String destination = RoutePath.onboarding;

    if (hasToken) {
      final currentMember = await ref.read(currentMemberProvider.future);
      final cameraLaunchRoute = CameraLaunchDestinationResolver.resolve(
        enabled: await SettingsStorage.getCameraLaunch(),
        isCameraPermissionGranted: (await Permission.camera.status).isGranted,
        role: currentMember?.role ?? RoleEnum.user,
      );

      destination = cameraLaunchRoute ?? RoutePath.home;
    }

    debugPrint('SplashScreen: navigating to $destination');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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
