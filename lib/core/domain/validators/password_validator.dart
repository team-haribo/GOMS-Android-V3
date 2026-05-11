/// 비밀번호 검증 로직을 중앙화하는 클래스
class PasswordValidator {
  /// 비밀번호 형식 검증 정규식
  /// 요구사항: 영문자 + 숫자 + 특수문자(!@#$%^&?~) 조합, 최소 6자
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&?~])[a-zA-Z\d!@#$%^&?~]{6,}$',
  );

  static const String passwordRequirement =
      '영문, 숫자, 특수문자(!@#\$%^&?~)를 포함하여 6자 이상';

  /// 비밀번호 유효성 검증
  /// 
  /// 최소 6자 이상이며, 영문자, 숫자, 특수문자를 모두 포함해야 합니다.
  /// 
  /// [password]: 검증할 비밀번호
  /// 반환값: null (유효함) 또는 에러 메시지
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (password.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다';
    }

    if (!passwordRegex.hasMatch(password)) {
      return passwordRequirement;
    }

    return null;
  }

  /// 비밀번호 형식이 유효한지 확인 (boolean 반환)
  static bool isValidPassword(String password) {
    return password.isNotEmpty && passwordRegex.hasMatch(password);
  }

  /// 두 비밀번호가 일치하는지 확인
  /// 
  /// [password]: 첫 번째 비밀번호
  /// [passwordConfirm]: 확인 비밀번호
  /// 반환값: null (일치) 또는 에러 메시지
  static String? validatePasswordMatch(String password, String passwordConfirm) {
    if (password.isEmpty || passwordConfirm.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (password != passwordConfirm) {
      return '비밀번호가 일치하지 않습니다';
    }

    return null;
  }
}
