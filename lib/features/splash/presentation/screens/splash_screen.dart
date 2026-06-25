import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/utils/camera_launch_destination_resolver.dart';
import 'package:goms/core/utils/settings_storage.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';
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
    debugPrint('SplashScreen: starting auth check');

    final hasToken = await ref.read(authProvider.notifier).checkToken();

    if (!mounted) return;

    String destination = RoutePath.onboarding;

    if (hasToken) {
      final memberFuture = ref.read(currentMemberProvider.future);
      final cameraLaunchFuture = SettingsStorage.getCameraLaunch();
      final cameraPermissionFuture = Permission.camera.status;

      final currentMember = await memberFuture;
      final cameraLaunchRoute = CameraLaunchDestinationResolver.resolve(
        enabled: await cameraLaunchFuture,
        isCameraPermissionGranted: (await cameraPermissionFuture).isGranted,
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
