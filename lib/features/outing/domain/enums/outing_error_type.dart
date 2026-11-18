/// 외출 처리 중 앱이 구분해서 다루는 실패 종류.
///
/// 서버 응답을 이 값으로 바꾸는 규칙은 data 계층의
/// `OutingErrorTypeMapper`가 담당한다.
enum OutingErrorType {
  /// 학년별 외출 시작 시각 전에 외출을 시도함 (이슈 #157)
  outingTimeNotAllowed,
}
