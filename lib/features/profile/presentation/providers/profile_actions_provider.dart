import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/password_reset/data/providers/password_reset_data_providers.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_viewmodel.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';

/// 마이페이지 액션 결과. 화면은 [message]를 그대로 노출하기만 하면 된다.
typedef ProfileActionResult = ({bool ok, String message});

/// 마이페이지의 프로필/비밀번호 액션과 그 검증을 담당한다.
///
/// state는 프로필 이미지 변경(업로드/삭제)이 진행 중인지 여부다.
final profileActionsProvider =
    NotifierProvider.autoDispose<ProfileActionsNotifier, bool>(
  ProfileActionsNotifier.new,
);

class ProfileActionsNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// 갤러리에서 고른 이미지를 프로필로 올린다.
  /// 이미 진행 중이면 아무것도 하지 않고 null을 돌려준다.
  Future<ProfileActionResult?> uploadProfileImage(String imagePath) async {
    if (state) {
      return null;
    }

    state = true;
    try {
      final imageUrl = await ref
          .read(memberRepositoryProvider)
          .updateProfileImage(imagePath: imagePath);

      if (imageUrl.isNotEmpty) {
        ref
            .read(currentMemberProvider.notifier)
            .updateProfileImageUrl(imageUrl);
        ref.read(myOutingStatusProvider.notifier).reload();
      }

      return (ok: true, message: '프로필 사진이 변경되었어요.');
    } catch (error) {
      return (ok: false, message: _errorMessage(error));
    } finally {
      state = false;
    }
  }

  /// 프로필 이미지를 지우고 기본 프로필로 되돌린다.
  /// 이미 진행 중이면 아무것도 하지 않고 null을 돌려준다.
  Future<ProfileActionResult?> deleteProfileImage() async {
    if (state) {
      return null;
    }

    final currentImageUrl = switch (ref.read(currentMemberProvider)) {
      AsyncData(:final value) => value?.profileImageUrl ?? '',
      _ => '',
    };
    if (currentImageUrl.isEmpty) {
      return (ok: false, message: '이미 기본 프로필을 사용 중이에요.');
    }

    state = true;
    try {
      await ref.read(memberRepositoryProvider).deleteProfileImage();

      ref.read(currentMemberProvider.notifier).updateProfileImageUrl('');
      ref.read(myOutingStatusProvider.notifier).reload();

      return (ok: true, message: '기본 프로필로 변경되었어요.');
    } catch (error) {
      return (ok: false, message: _errorMessage(error));
    } finally {
      state = false;
    }
  }

  /// 현재 로그인한 멤버의 이메일로 비밀번호 재설정 인증 메일을 보내고
  /// 인증 플로우를 시작한다. ok가 true면 화면은 인증 화면으로 이동하면 된다.
  Future<ProfileActionResult> startPasswordReset() async {
    final email = switch (ref.read(currentMemberProvider)) {
      AsyncData(:final value) => value?.email,
      _ => null,
    };

    final trimmedEmail = email?.trim() ?? '';
    if (trimmedEmail.isEmpty) {
      return (ok: false, message: '이메일 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
    }

    try {
      await ref
          .read(passwordResetRemoteDataSourceProvider)
          .sendEmailVerification(
            SendEmailVerificationRequestDto(
              email: trimmedEmail,
              purpose: EmailVerificationPurpose.passwordChange,
            ),
          );
      ref.read(authFlowProvider.notifier).startResetPassword(trimmedEmail);

      return (ok: true, message: '');
    } catch (error) {
      return (ok: false, message: _errorMessage(error));
    }
  }
}

String _errorMessage(Object error) => error is DioException
    ? NetworkException.fromDioException(error).message
    : error.toString();
