/// 전화번호 검증 로직을 중앙화하는 클래스
class PhoneValidator {
  /// 한국 휴대폰 번호 형식 검증 정규식
  /// 010-1234-5678 형식을 지원합니다.
  static final RegExp phoneRegex = RegExp(r'^01[0-9]-\d{3,4}-\d{4}$');

  /// 전화번호 유효성 검증
  /// 
  /// 한국 휴대폰 번호 형식(010-1234-5678)을 확인합니다.
  /// 
  /// [phone]: 검증할 전화번호
  /// 반환값: null (유효함) 또는 에러 메시지
  static String? validatePhone(String phone) {
    final trimmed = phone.trim();

    if (trimmed.isEmpty) {
      return '전화번호를 입력해주세요';
    }

    if (!phoneRegex.hasMatch(trimmed)) {
      return '010-1234-5678 형식으로 입력해주세요';
    }

    return null;
  }

  /// 전화번호 형식이 유효한지 확인 (boolean 반환)
  static bool isValidPhone(String phone) {
    return phoneRegex.hasMatch(phone.trim());
  }
}
