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
    Future.microtask(_checkAuthAndNavigate);
  }

  Future<void> _checkAuthAndNavigate() async {
    debugPrint('SplashScreen: starting auth check');

    // Keep the splash visible for at least 1s: if the auth check finishes
    // sooner we wait out the remainder, otherwise we navigate the moment it's
    // done. Started here so the floor counts from when the splash appears.
    final minimumDisplay = Future<void>.delayed(const Duration(seconds: 1));
    String destination = RoutePath.onboarding;

    try {
      final hasToken = await ref.read(authProvider.notifier).checkToken();

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
    } catch (error, stackTrace) {
      debugPrint('SplashScreen: auth check failed, falling back to onboarding: $error');
      debugPrintStack(stackTrace: stackTrace);
      destination = RoutePath.onboarding;
    }

    await minimumDisplay;

    if (!mounted) return;

    debugPrint('SplashScreen: navigating to $destination');
    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showAppBar: false,
      body: Center(child: AppIcons.gomsLogo(width: 80, height: 80)),
    );
  }
}
