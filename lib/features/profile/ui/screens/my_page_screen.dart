import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/enums/app_theme_option.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/password_reset/data/providers/password_reset_data_providers.dart';
import 'package:goms/features/auth/session/ui/providers/session_provider.dart';
import 'package:goms/features/auth/shared/ui/providers/auth_flow_provider.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/ui/providers/current_member_provider.dart';
import 'package:goms/features/outing/ui/providers/my_outing_status_provider.dart';
import 'package:goms/features/profile/ui/widgets/account_actions_section.dart';
import 'package:goms/features/profile/ui/widgets/profile_summary_section.dart';
import 'package:goms/features/profile/ui/providers/settings_provider.dart';
import 'package:goms/features/profile/ui/widgets/settings_section.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';
import 'package:image_picker/image_picker.dart';

final _profileImageUploadingProvider = NotifierProvider.autoDispose
    .family<_ProfileImageUploadingNotifier, bool, Object>(
  _ProfileImageUploadingNotifier.new,
);

class _ProfileImageUploadingNotifier extends Notifier<bool> {
  _ProfileImageUploadingNotifier(this.key);

  final Object key;

  @override
  bool build() => false;

  void setUploading(bool value) => state = value;
}

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  late final Object _providerKey;

  @override
  void initState() {
    super.initState();
    _providerKey = Object();
  }

  void _showThemePicker(BuildContext context, AppThemeOption current) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: AppThemeOption.values.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(option.themeMode);
              context.pop();
            },
            child: Text(
              option.label,
              style: AppTextStyles.text2.withColor(CupertinoColors.systemBlue),
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => context.pop(),
          child: Text(
            '취소',
            style: AppTextStyles.text1.withColor(CupertinoColors.systemBlue),
          ),
        ),
      ),
    );
  }

  void _showPermissionDeniedSnackBar(String feature) {
    _showSnackBar('$feature 기능을 사용하려면 권한이 필요합니다.');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showDioError(DioException error) {
    if (!mounted) {
      return;
    }

    _showSnackBar(NetworkException.fromDioException(error).message);
  }

  void _showUnknownError(Object error) {
    if (!mounted) {
      return;
    }

    _showSnackBar(error.toString());
  }

  Future<void> _startPasswordResetFlow(String? email) async {
    final trimmedEmail = email?.trim() ?? '';
    if (trimmedEmail.isEmpty) {
      _showSnackBar('이메일 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
      return;
    }

    try {
      await ref.read(passwordResetRepositoryProvider).sendEmailVerification(
            email: trimmedEmail,
            purpose: EmailVerificationPurpose.passwordChange,
          );
      ref.read(authFlowProvider.notifier).startResetPassword(trimmedEmail);

      if (!mounted) {
        return;
      }

      context.go(RoutePath.verify, extra: RoutePath.resetPassword);
    } on DioException catch (error) {
      _showDioError(error);
    } catch (error) {
      _showUnknownError(error);
    }
  }

  void _setProfileImageUploading(bool value) {
    ref
        .read(_profileImageUploadingProvider(_providerKey).notifier)
        .setUploading(value);
  }

  Future<void> _pickAndUploadProfileImage() async {
    if (ref.read(_profileImageUploadingProvider(_providerKey))) {
      return;
    }

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedImage == null) {
      return;
    }

    _setProfileImageUploading(true);
    try {
      final imageUrl = await ref
          .read(memberRepositoryProvider)
          .updateProfileImage(imagePath: pickedImage.path);

      if (!mounted) {
        return;
      }

      if (imageUrl.isNotEmpty) {
        ref
            .read(currentMemberProvider.notifier)
            .updateProfileImageUrl(imageUrl);
      }

      _showSnackBar('프로필 사진이 변경되었어요.');
    } on DioException catch (error) {
      _showDioError(error);
    } catch (error) {
      _showUnknownError(error);
    } finally {
      _setProfileImageUploading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUploadingProfileImage = ref.watch(
      _profileImageUploadingProvider(_providerKey),
    );
    final role = ref.watch(roleProvider);
    final currentMember = switch (ref.watch(currentMemberProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final myOutingStatus = switch (ref.watch(myOutingStatusProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final textColor = context.mainTextColor;
    final subColor = context.sub1Color;
    final sub2Color = context.sub2Color;
    final surfaceColor = context.surfaceColor;

    final currentThemeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final selectedThemeOption = currentThemeMode.option;

    final settings = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final showClock = settings?.showClock ?? false;
    final outingPushAlarm = settings?.outingPushAlarm ?? true;
    final cameraLaunch = settings?.cameraLaunch ?? false;

    return BaseScaffold(
      showAppBarLogo: true,
      role: role,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSummarySection(
              role: role,
              name: currentMember?.name ?? '정보 없음',
              profileImageUrl: currentMember?.profileImageUrl ?? '',
              onTapProfileImage: _pickAndUploadProfileImage,
              isUploadingProfileImage: isUploadingProfileImage,
              grade: currentMember?.grade,
              major: currentMember?.department.name.toUpperCase(),
              lateCount: myOutingStatus?.lateCount,
              textColor: textColor,
              subColor: sub2Color,
              surfaceColor: surfaceColor,
            ),
            AppGap.v24,
            const Divider(),
            AppGap.v24,
            SettingsSection(
              selectedThemeOption: selectedThemeOption,
              showClock: showClock,
              outingPushAlarm: outingPushAlarm,
              cameraLaunch: cameraLaunch,
              textColor: textColor,
              subColor: subColor,
              surfaceColor: surfaceColor,
              role: role,
              onTapTheme: () => _showThemePicker(context, selectedThemeOption),
              onToggleShowClock: (value) {
                ref.read(settingsProvider.notifier).setShowClock(value);
              },
              onToggleOutingPushAlarm: (value) async {
                final granted = await ref
                    .read(settingsProvider.notifier)
                    .setOutingPushAlarm(value);
                if (!granted && mounted) {
                  _showPermissionDeniedSnackBar('외출제 푸시 알림');
                }
              },
              onToggleCameraLaunch: (value) async {
                final granted = await ref
                    .read(settingsProvider.notifier)
                    .setCameraLaunch(value);
                if (!granted && mounted) {
                  _showPermissionDeniedSnackBar(
                    role == RoleEnum.admin ? 'QR 생성 바로 켜기' : '카메라 바로 켜기',
                  );
                }
              },
            ),
            AppGap.v24,
            const Divider(),
            AppGap.v24,
            AccountActionsSection(
              textColor: textColor,
              onTapResetPassword: () =>
                  _startPasswordResetFlow(currentMember?.email),
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
