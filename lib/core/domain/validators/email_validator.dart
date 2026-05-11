/// 이메일 검증 로직을 중앙화하는 클래스
class EmailValidator {
  /// 학교 이메일 형식 검증 (s + 숫자)
  static final RegExp schoolEmailRegex = RegExp(r'^s\d+$');

  /// 이메일 유효성 검증
  /// 
  /// 학교 이메일 형식(s + 숫자)에 맞는지 확인합니다.
  /// 
  /// [email]: 검증할 이메일 주소
  /// 반환값: null (유효함) 또는 에러 메시지
  static String? validateSchoolEmail(String email) {
    final trimmed = email.trim();
    
    if (trimmed.isEmpty) {
      return '이메일을 입력해주세요';
    }
    
    if (!schoolEmailRegex.hasMatch(trimmed)) {
      return '학교 이메일 형식이 아닙니다';
    }
    
    return null;
  }

  /// 이메일 형식이 유효한지 확인 (boolean 반환)
  static bool isValidSchoolEmail(String email) {
    return schoolEmailRegex.hasMatch(email.trim());
  }
}
