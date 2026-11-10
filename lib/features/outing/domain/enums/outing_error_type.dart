/// 외출 API가 내려주는 실패 응답 종류.
///
/// 서버 응답에는 에러 코드 없이 `status`와 `message`만 담기므로
/// 두 값으로 종류를 구분한다. 백엔드 `ErrorCode`의 문구가 바뀌면 함께 수정해야 한다.
enum OutingErrorType {
  /// 백엔드 `OUTING_TIME_NOT_ALLOWED`: 학년별 외출 시작 시각 전 외출 시도 (이슈 #157)
  outingTimeNotAllowed(
    statusCode: 403,
    serverMessage: '외출 가능 시간이 아닙니다.',
  );

  const OutingErrorType({
    required this.statusCode,
    required this.serverMessage,
  });

  final int statusCode;
  final String serverMessage;

  /// 서버 응답에 맞는 실패 종류를 찾는다. 해당하는 종류가 없으면 null.
  static OutingErrorType? fromResponse({
    required int? statusCode,
    required String message,
  }) {
    final trimmedMessage = message.trim();
    for (final type in values) {
      if (type.statusCode == statusCode &&
          type.serverMessage == trimmedMessage) {
        return type;
      }
    }
    return null;
  }
}
