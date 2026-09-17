import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/splash/presentation/routes/splash_route_path.dart';
import 'package:goms/features/outing/presentation/routes/outing_route_path.dart';
import 'package:goms/features/qr/presentation/routes/camera_launch_destination_resolver.dart';
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
    // 스플래시 화면 최소 표시 시간
    await Future.delayed(const Duration(seconds: 2));

    debugPrint('SplashScreen: starting auth check');

    String destination = SplashRoutePath.onboarding;

    try {
      final hasToken = await ref.read(authProvider.notifier).checkToken();
      if (!mounted) return;

      if (hasToken) {
        final currentMember = await ref.read(currentMemberProvider.future);
        final cameraLaunchRoute = CameraLaunchDestinationResolver.resolve(
          enabled: await SettingsStorage.getCameraLaunch(),
          isCameraPermissionGranted: (await Permission.camera.status).isGranted,
          role: currentMember?.role ?? RoleEnum.user,
        );

        destination = cameraLaunchRoute ?? OutingRoutePath.home;
      }
    } catch (error, stackTrace) {
      // 네트워크/토큰 오류 시 예외 전파로 스플래시에 멈추지 않도록 온보딩으로 폴백
      debugPrint('SplashScreen: auth check failed, falling back to onboarding: $error');
      debugPrintStack(stackTrace: stackTrace);
      destination = SplashRoutePath.onboarding;
    }

    debugPrint('SplashScreen: navigating to $destination');

    // ponytail: navigate directly — addPostFrameCallback does NOT schedule a
    // frame, and the static splash pumps no frames in release, so the callback
    // never fired and the app hung on splash. We're already past build here
    // (after the delay + awaits), so calling context.go directly is safe.
    if (!mounted) return;
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
