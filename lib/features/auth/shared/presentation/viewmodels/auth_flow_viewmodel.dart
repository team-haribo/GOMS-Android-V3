import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';

const _schoolEmailDomain = '@gsm.hs.kr';

bool isAllowedSchoolEmail(String email) {
  final trimmedEmail = email.trim();
  if (trimmedEmail.isEmpty) {
    return false;
  }

  final normalizedEmail = normalizeSchoolEmail(trimmedEmail);
  return RegExp(r'^[^@\s]+@gsm\.hs\.kr$').hasMatch(normalizedEmail);
}

String normalizeSchoolEmail(String email) {
  final trimmedEmail = email.trim();
  if (trimmedEmail.isEmpty) {
    return trimmedEmail;
  }
  if (trimmedEmail.contains('@')) {
    return trimmedEmail;
  }
  return '$trimmedEmail$_schoolEmailDomain';
}

int inferGradeFromEmail(String email) {
  final localPart = normalizeSchoolEmail(email).split('@').first;
  final match = RegExp(r'^s(\d)').firstMatch(localPart);
  if (match == null) {
    return 1;
  }
  return int.tryParse(match.group(1)!) ?? 1;
}

class AuthFlowState {
  const AuthFlowState({
    this.email = '',
    this.purpose,
    this.verifiedToken,
  });

  final String email;
  final EmailVerificationPurpose? purpose;
  final String? verifiedToken;

  AuthFlowState copyWith({
    String? email,
    EmailVerificationPurpose? purpose,
    Object? verifiedToken = _unset,
  }) {
    return AuthFlowState(
      email: email ?? this.email,
      purpose: purpose ?? this.purpose,
      verifiedToken: identical(verifiedToken, _unset)
          ? this.verifiedToken
          : verifiedToken as String?,
    );
  }

  static const _unset = Object();
}

final authFlowProvider = NotifierProvider<AuthFlowNotifier, AuthFlowState>(
  AuthFlowNotifier.new,
);

class AuthFlowNotifier extends Notifier<AuthFlowState> {
  @override
  AuthFlowState build() => const AuthFlowState();

  void startSignup(String email) {
    state = AuthFlowState(
      email: normalizeSchoolEmail(email),
      purpose: EmailVerificationPurpose.signup,
    );
  }

  void startResetPassword(String email) {
    state = AuthFlowState(
      email: normalizeSchoolEmail(email),
      purpose: EmailVerificationPurpose.passwordChange,
    );
  }

  void setVerifiedToken(String verifiedToken) {
    state = state.copyWith(verifiedToken: verifiedToken);
  }

  void clearVerifiedToken() {
    state = state.copyWith(verifiedToken: null);
  }

  void clear() {
    state = const AuthFlowState();
  }
}