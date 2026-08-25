import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';
import 'package:goms/features/auth/shared/presentation/routes/verify_route_extra.dart';
import 'package:goms/features/profile/presentation/providers/profile_actions_provider.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';
import 'package:goms/features/profile/presentation/widgets/account_actions_section.dart';
import 'package:goms/features/profile/presentation/widgets/profile_image_option_sheet.dart';
import 'package:goms/features/profile/presentation/widgets/profile_summary_section.dart';
import 'package:goms/features/profile/presentation/widgets/settings_section.dart';
import 'package:image_picker/image_picker.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  void _showProfileImageOptions() {
    if (ref.read(profileActionsProvider)) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (sheetContext) => ProfileImageOptionSheet(
        onPickFromGallery: () {
          Navigator.pop(sheetContext);
          _pickAndUploadProfileImage();
        },
        onUseDefault: () {
          Navigator.pop(sheetContext);
          _deleteProfileImage();
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// 진행 중(null)이면 조용히 넘기고, 그 외에는 결과 메시지를 그대로 노출한다.
  void _showActionResult(ProfileActionResult? result) {
    if (result == null || !mounted) {
      return;
    }

    _showSnackBar(result.message);
  }

  Future<void> _startPasswordResetFlow() async {
    final result =
        await ref.read(profileActionsProvider.notifier).startPasswordReset();

    if (!mounted) {
      return;
    }

    if (!result.ok) {
      _showSnackBar(result.message);
      return;
    }

    context.go(
      RoutePath.verify,
      extra: const VerifyRouteExtra(
        redirectPath: RoutePath.resetPassword,
        backPath: RoutePath.myPage,
      ),
    );
  }

  Future<void> _pickAndUploadProfileImage() async {
    if (ref.read(profileActionsProvider)) {
      return;
    }

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedImage == null) {
      return;
    }

    _showActionResult(
      await ref
          .read(profileActionsProvider.notifier)
          .uploadProfileImage(pickedImage.path),
    );
  }

  Future<void> _deleteProfileImage() async {
    _showActionResult(
      await ref.read(profileActionsProvider.notifier).deleteProfileImage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showAppBarLogo: true,
      role: ref.watch(roleProvider),
      contentPadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSummarySection(onTapProfileImage: _showProfileImageOptions),
            SizedBox(height: 24.h),
            const Divider(height: 1),
            SizedBox(height: 24.h),
            const SettingsSection(),
            SizedBox(height: 24.h),
            const Divider(height: 1),
            SizedBox(height: 24.h),
            AccountActionsSection(
              onTapResetPassword: _startPasswordResetFlow,
              onTapLogout: () => GomsDialog.confirm(
                title: '로그아웃',
                content: '\n 로그아웃 하시겠습니까?',
                confirmText: '로그아웃',
                onConfirm: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(RoutePath.onboarding);
                  }
                },
              ).show(context),
              onTapDeleteAccount: () => context.push(RoutePath.deleteAccount),
            ),
          ],
        ),
      ),
    );
  }
}
