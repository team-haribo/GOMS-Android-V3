import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/password_reset/data/providers/password_reset_data_providers.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_viewmodel.dart';
import 'package:goms/features/auth/shared/presentation/routes/verify_route_extra.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';
import 'package:goms/features/profile/presentation/viewmodels/settings_viewmodel.dart';
import 'package:goms/features/profile/presentation/viewmodels/profile_image_uploading_viewmodel.dart';
import 'package:goms/core/widgets/buttons/toggle_button.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';
import 'package:goms/core/widgets/bottom_sheets/selection_bottom_sheet.dart';
import 'package:goms/features/profile/presentation/widgets/profile_image_option_sheet.dart';
import 'package:image_picker/image_picker.dart';

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
    SelectionBottomSheet.show<AppThemeOption>(
      context,
      title: '앱 테마 설정',
      items: AppThemeOption.values,
      itemLabel: (option) => option.label,
      selected: current,
      onSelected: (option) {
        ref.read(themeModeProvider.notifier).setThemeMode(option.themeMode);
      },
    );
  }

  void _showProfileImageOptions() {
    if (ref.read(profileImageUploadingProvider(_providerKey))) {
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
      await ref.read(passwordResetRemoteDataSourceProvider).sendEmailVerification(
            SendEmailVerificationRequestDto(
              email: trimmedEmail,
              purpose: EmailVerificationPurpose.passwordChange,
            ),
          );
      ref.read(authFlowProvider.notifier).startResetPassword(trimmedEmail);

      if (!mounted) {
        return;
      }

      context.go(
        RoutePath.verify,
        extra: const VerifyRouteExtra(
          redirectPath: RoutePath.resetPassword,
          backPath: RoutePath.myPage,
        ),
      );
    } on DioException catch (error) {
      _showDioError(error);
    } catch (error) {
      _showUnknownError(error);
    }
  }

  void _setProfileImageUploading(bool value) {
    ref
        .read(profileImageUploadingProvider(_providerKey).notifier)
        .setUploading(value);
  }

  Future<void> _pickAndUploadProfileImage() async {
    if (ref.read(profileImageUploadingProvider(_providerKey))) {
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
        ref.read(myOutingStatusProvider.notifier).reload();
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

  Future<void> _deleteProfileImage() async {
    if (ref.read(profileImageUploadingProvider(_providerKey))) {
      return;
    }

    final currentImageUrl = switch (ref.read(currentMemberProvider)) {
      AsyncData(:final value) => value?.profileImageUrl ?? '',
      _ => '',
    };
    if (currentImageUrl.isEmpty) {
      _showSnackBar('이미 기본 프로필을 사용 중이에요.');
      return;
    }

    _setProfileImageUploading(true);
    try {
      await ref.read(memberRepositoryProvider).deleteProfileImage();

      if (!mounted) {
        return;
      }

      ref.read(currentMemberProvider.notifier).updateProfileImageUrl('');
      ref.read(myOutingStatusProvider.notifier).reload();
      _showSnackBar('기본 프로필로 변경되었어요.');
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
    final isUploadingProfileImage =
        ref.watch(profileImageUploadingProvider(_providerKey));
    final role = ref.watch(roleProvider);
    final currentMember = switch (ref.watch(currentMemberProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final myOutingStatus = switch (ref.watch(myOutingStatusProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

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
      contentPadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSummarySection(
              role: role,
              name: currentMember?.name ?? '정보 없음',
              profileImageUrl: currentMember?.profileImageUrl ?? '',
              onTapProfileImage: _showProfileImageOptions,
              isUploadingProfileImage: isUploadingProfileImage,
              grade: currentMember?.grade,
              major: currentMember?.department.name.toUpperCase(),
              lateCount: myOutingStatus?.lateCount,
            ),
            SizedBox(height: 24.h),
            const Divider(height: 1),
            SizedBox(height: 24.h),
            SettingsSection(
              selectedThemeOption: selectedThemeOption,
              showClock: showClock,
              outingPushAlarm: outingPushAlarm,
              cameraLaunch: cameraLaunch,
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
            SizedBox(height: 24.h),
            const Divider(height: 1),
            SizedBox(height: 24.h),
            AccountActionsSection(
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

// ---------------------------------------------------------------------------
// ProfileSummarySection (Figma 569-10152)
// ---------------------------------------------------------------------------

class ProfileSummarySection extends StatelessWidget {
  const ProfileSummarySection({
    super.key,
    required this.role,
    required this.name,
    required this.profileImageUrl,
    required this.onTapProfileImage,
    required this.isUploadingProfileImage,
    this.grade,
    this.major,
    this.lateCount,
  });

  final RoleEnum role;
  final String name;
  final String profileImageUrl;
  final VoidCallback onTapProfileImage;
  final bool isUploadingProfileImage;
  final int? grade;
  final String? major;
  final int? lateCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTapProfileImage,
          child: SizedBox(
            width: 64.r,
            height: 64.r,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ProfileAvatar(
                  radius: 32.r,
                  imageUrl: profileImageUrl,
                  backgroundColor: context.surfaceColor,
                ),
                if (isUploadingProfileImage)
                  Positioned.fill(
                    child: Center(
                      child: SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child:
                            const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: -4.w,
                  child: role == RoleEnum.admin
                      ? AppIcons.adminEdit(width: 24.r, height: 24.r)
                      : AppIcons.edit(width: 24.r, height: 24.r),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title3.withColor(context.mainTextColor),
              ),
              SizedBox(height: 4.h),
              Text(
                _buildStudentInfoText(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption1.withColor(context.sub2Color),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('지각 횟수', style: AppTextStyles.text2.withColor(context.sub2Color)),
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                style: AppTextStyles.title3,
                children: [
                  TextSpan(
                    text: lateCount == null ? '-' : '$lateCount',
                    style: AppTextStyles.title3.withColor(AppColors.negative),
                  ),
                  WidgetSpan(child: SizedBox(width: 2.w)),
                  TextSpan(
                    text: '번',
                    style:
                        AppTextStyles.title3.withColor(context.mainTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _buildStudentInfoText() {
    final gradeText = grade == null ? '-' : '$grade기';
    final majorText = (major == null || major!.isEmpty) ? '-' : '$major과';
    return '$gradeText | $majorText';
  }
}

// ---------------------------------------------------------------------------
// SettingsSection (Figma 569-10165)
// ---------------------------------------------------------------------------

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.selectedThemeOption,
    required this.showClock,
    required this.outingPushAlarm,
    required this.cameraLaunch,
    required this.role,
    required this.onTapTheme,
    required this.onToggleShowClock,
    required this.onToggleOutingPushAlarm,
    required this.onToggleCameraLaunch,
  });

  final AppThemeOption selectedThemeOption;
  final bool showClock;
  final bool outingPushAlarm;
  final bool cameraLaunch;
  final RoleEnum role;
  final VoidCallback onTapTheme;
  final ValueChanged<bool> onToggleShowClock;
  final ValueChanged<bool> onToggleOutingPushAlarm;
  final ValueChanged<bool> onToggleCameraLaunch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '앱 테마 설정',
          style: AppTextStyles.text1.withColor(context.mainTextColor),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTapTheme,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedThemeOption.label,
                    style: AppTextStyles.text2.withColor(context.sub1Color),
                  ),
                ),
                AppIcons.downArrow(
                  width: 24.r,
                  height: 24.r,
                  color: context.sub1Color,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),
        _SettingsToggleItem(
          title: '시계 나타내기',
          description: '프로필 카드에 초 단위의 시간을 나타내요',
          value: showClock,
          onChanged: onToggleShowClock,
          role: role,
        ),
        if (role != RoleEnum.admin) ...[
          SizedBox(height: 14.h),
          _SettingsToggleItem(
            title: '외출제 푸시 알림',
            description: '외출할 시간이 될 때마다 알려드려요',
            value: outingPushAlarm,
            onChanged: onToggleOutingPushAlarm,
            role: role,
          ),
        ],
        SizedBox(height: 14.h),
        _SettingsToggleItem(
          title: role == RoleEnum.admin ? 'QR 생성 바로 켜기' : '카메라 바로 켜기',
          description: role == RoleEnum.admin
              ? '앱을 실행하면 즉시 QR 발급 화면이 열려요'
              : '앱을 실행하면 즉시 카메라가 켜져요',
          value: cameraLaunch,
          onChanged: onToggleCameraLaunch,
          role: role,
        ),
      ],
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  const _SettingsToggleItem({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.role,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final RoleEnum role;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.text1.withColor(context.mainTextColor)),
              SizedBox(height: 4.h),
              Text(
                description,
                style: AppTextStyles.caption1.withColor(context.sub2Color),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          child: ToggleButton(type: role, value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AccountActionsSection (Figma 569-10190)
// ---------------------------------------------------------------------------

class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({
    super.key,
    required this.onTapResetPassword,
    required this.onTapLogout,
    required this.onTapDeleteAccount,
  });

  final VoidCallback onTapResetPassword;
  final VoidCallback onTapLogout;
  final VoidCallback onTapDeleteAccount;

  @override
  Widget build(BuildContext context) {
    final mainText = context.mainTextColor;
    return Column(
      children: [
        _AccountActionRow(
          icon: AppIcons.setting(width: 24.r, height: 24.r, color: mainText),
          title: '비밀번호 재설정',
          titleColor: mainText,
          onTap: onTapResetPassword,
        ),
        SizedBox(height: 16.h),
        _AccountActionRow(
          icon: AppIcons.logout(
            width: 24.r,
            height: 24.r,
            color: AppColors.negative,
          ),
          title: '로그아웃',
          titleColor: AppColors.negative,
          onTap: onTapLogout,
        ),
        SizedBox(height: 16.h),
        _AccountActionRow(
          icon: AppIcons.user(
            width: 24.r,
            height: 24.r,
            color: AppColors.negative,
          ),
          title: '회원탈퇴',
          titleColor: AppColors.negative,
          onTap: onTapDeleteAccount,
        ),
      ],
    );
  }
}

class _AccountActionRow extends StatelessWidget {
  const _AccountActionRow({
    required this.icon,
    required this.title,
    required this.titleColor,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final Color titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            icon,
            SizedBox(width: 4.w),
            Expanded(
              child:
                  Text(title, style: AppTextStyles.text2.withColor(titleColor)),
            ),
            AppIcons.arrow(width: 24.r, height: 24.r, color: context.mainTextColor),
          ],
        ),
      ),
    );
  }
}
