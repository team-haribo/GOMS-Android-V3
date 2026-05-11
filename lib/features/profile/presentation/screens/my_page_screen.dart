import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      profileImageUploadingProvider(_providerKey),
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
      contentPadding: EdgeInsets.fromLTRB(
        context.horizontalPadding,
        context.isSmallPhoneLayout ? 12 : 16,
        context.horizontalPadding,
        context.isSmallPhoneLayout ? 16 : 24,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final shouldScroll = constraints.maxHeight < 640;
          final isDenseLayout = constraints.maxHeight < 560;
          final dividerSpacing = isDenseLayout
              ? context.responsive(compact: 6, normal: 8)
              : context.responsive(compact: 12, normal: 24);
          final sectionInnerSpacing = isDenseLayout
              ? context.responsive(compact: 10, normal: 12)
              : context.responsive(compact: 20, normal: 36);

          final content = Column(
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
                isCompact: isDenseLayout,
              ),
              SizedBox(height: dividerSpacing),
              const Divider(height: 1),
              SizedBox(height: dividerSpacing),
              SettingsSection(
                selectedThemeOption: selectedThemeOption,
                showClock: showClock,
                outingPushAlarm: outingPushAlarm,
                cameraLaunch: cameraLaunch,
                textColor: textColor,
                subColor: subColor,
                surfaceColor: surfaceColor,
                role: role,
                sectionSpacing: sectionInnerSpacing,
                themeTileVerticalPadding: isDenseLayout ? 8 : AppSpacing.s12,
                onTapTheme: () =>
                    _showThemePicker(context, selectedThemeOption),
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
              const SizedBox(height: AppSpacing.s24),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.s24),
              AccountActionsSection(
                textColor: textColor,
                rowVerticalPadding: AppSpacing.s16,
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
          );

          if (shouldScroll) {
            return SingleChildScrollView(child: content);
          }

          return SizedBox(
            height: constraints.maxHeight,
            child: content,
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ProfileSummarySection (moved from widgets/profile_summary_section.dart)
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
    required this.textColor,
    required this.subColor,
    required this.surfaceColor,
    this.isCompact = false,
  });

  final RoleEnum role;
  final String name;
  final String profileImageUrl;
  final VoidCallback onTapProfileImage;
  final bool isUploadingProfileImage;
  final int? grade;
  final String? major;
  final int? lateCount;
  final Color textColor;
  final Color subColor;
  final Color surfaceColor;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = isCompact ? 30.0 : 36.0;
    final infoSpacing = isCompact ? AppGap.h12 : AppGap.h16;
    final lateCountSpacing = isCompact ? AppGap.h8 : AppGap.h12;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: onTapProfileImage,
              child: Stack(
                children: [
                  ProfileAvatar(
                    radius: avatarRadius,
                    imageUrl: profileImageUrl,
                    backgroundColor: surfaceColor,
                  ),
                  if (isUploadingProfileImage)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: role == RoleEnum.admin
                  ? AppIcons.adminEdit()
                  : AppIcons.edit(),
            ),
          ],
        ),
        infoSpacing,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title3.withColor(textColor),
              ),
              AppGap.v4,
              Text(
                _buildStudentInfoText(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption1.withColor(subColor),
              ),
            ],
          ),
        ),
        lateCountSpacing,
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('지각 횟수', style: AppTextStyles.text2.withColor(subColor)),
            AppGap.v4,
            RichText(
              text: TextSpan(
                style: AppTextStyles.title3,
                children: [
                  TextSpan(
                    text: lateCount == null ? '-' : '$lateCount',
                    style: AppTextStyles.title3.withColor(AppColors.negative),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '번',
                    style: AppTextStyles.title3.withColor(
                      context.mainTextColor,
                    ),
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
// SettingsSection (moved from widgets/settings_section.dart)
// ---------------------------------------------------------------------------

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.selectedThemeOption,
    required this.showClock,
    required this.outingPushAlarm,
    required this.cameraLaunch,
    required this.textColor,
    required this.subColor,
    required this.surfaceColor,
    required this.role,
    required this.sectionSpacing,
    required this.themeTileVerticalPadding,
    required this.onTapTheme,
    required this.onToggleShowClock,
    required this.onToggleOutingPushAlarm,
    required this.onToggleCameraLaunch,
  });

  final AppThemeOption selectedThemeOption;
  final bool showClock;
  final bool outingPushAlarm;
  final bool cameraLaunch;
  final Color textColor;
  final Color subColor;
  final Color surfaceColor;
  final RoleEnum role;
  final double sectionSpacing;
  final double themeTileVerticalPadding;
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
        AppGap.v12,
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTapTheme,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: themeTileVerticalPadding,
            ),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedThemeOption.label,
                    style: AppTextStyles.text2.withColor(subColor),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, color: subColor),
              ],
            ),
          ),
        ),
        SizedBox(height: sectionSpacing),
        _SettingsToggleItem(
          title: '시계 나타내기',
          description: '프로필 카드에 초 단위의 시간을 나타내요',
          value: showClock,
          onChanged: onToggleShowClock,
          textColor: textColor,
          subColor: subColor,
          role: role,
        ),
        if (role != RoleEnum.admin) ...[
          SizedBox(height: sectionSpacing),
          _SettingsToggleItem(
            title: '외출제 푸시 알림',
            description: '외출할 시간이 될 때마다 알려드려요',
            value: outingPushAlarm,
            onChanged: onToggleOutingPushAlarm,
            textColor: textColor,
            subColor: subColor,
            role: role,
          ),
        ],
        SizedBox(height: sectionSpacing),
        _SettingsToggleItem(
          title: role == RoleEnum.admin ? 'QR 생성 바로 켜기' : '카메라 바로 켜기',
          description: role == RoleEnum.admin
              ? '앱을 실행하면 즉시 QR 발급 화면이 열려요'
              : '앱을 실행하면 즉시 카메라가 켜져요',
          value: cameraLaunch,
          onChanged: onToggleCameraLaunch,
          textColor: textColor,
          subColor: subColor,
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
    required this.textColor,
    required this.subColor,
    required this.role,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color textColor;
  final Color subColor;
  final RoleEnum role;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.text1.withColor(textColor)),
              AppGap.v4,
              Text(
                description,
                style: AppTextStyles.caption1.withColor(subColor),
              ),
            ],
          ),
        ),
        ToggleButton(type: role, value: value, onChanged: onChanged),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AccountActionsSection (moved from widgets/account_actions_section.dart)
// ---------------------------------------------------------------------------

class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({
    super.key,
    required this.textColor,
    required this.rowVerticalPadding,
    required this.onTapResetPassword,
    required this.onTapLogout,
    required this.onTapDeleteAccount,
  });

  final Color textColor;
  final double rowVerticalPadding;
  final VoidCallback onTapResetPassword;
  final VoidCallback onTapLogout;
  final VoidCallback onTapDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AccountActionRow(
          icon: AppIcons.setting(color: textColor),
          title: '비밀번호 재설정',
          textColor: textColor,
          verticalPadding: rowVerticalPadding,
          onTap: onTapResetPassword,
        ),
        _AccountActionRow(
          icon: AppIcons.forcedOuting(color: AppColors.negative),
          title: '로그아웃',
          textColor: AppColors.negative,
          chevronColor: textColor,
          verticalPadding: rowVerticalPadding,
          onTap: onTapLogout,
        ),
        _AccountActionRow(
          icon: AppIcons.logout(color: AppColors.negative),
          title: '회원탈퇴',
          textColor: AppColors.negative,
          chevronColor: textColor,
          verticalPadding: rowVerticalPadding,
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
    required this.textColor,
    required this.verticalPadding,
    required this.onTap,
    this.chevronColor,
  });

  final Widget icon;
  final String title;
  final Color textColor;
  final double verticalPadding;
  final VoidCallback onTap;
  final Color? chevronColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Row(
          children: [
            icon is Icon
                ? Icon(
                    (icon as Icon).icon,
                    size: 24,
                    color: textColor,
                  )
                : icon,
            AppGap.h8,
            Expanded(
              child:
                  Text(title, style: AppTextStyles.text2.withColor(textColor)),
            ),
            AppIcons.arrow(color: chevronColor ?? textColor),
          ],
        ),
      ),
    );
  }
}
