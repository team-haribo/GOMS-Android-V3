import 'package:goms/features/outing/domain/enums/outing_error_type.dart';

/// 외출 API 실패 응답을 [OutingErrorType]으로 바꾼다.
///
/// 서버 응답에는 에러 코드 없이 `status`와 `message`만 담기므로
/// 두 값으로 종류를 구분한다. 백엔드 `ErrorCode`의 문구가 바뀌면 함께 수정해야 한다.
class OutingErrorTypeMapper {
  const OutingErrorTypeMapper._();

  /// 백엔드 `OUTING_TIME_NOT_ALLOWED`
  static const _outingTimeNotAllowedStatusCode = 403;
  static const outingTimeNotAllowedMessage = '외출 가능 시간이 아닙니다.';

  /// 서버 응답에 맞는 실패 종류를 찾는다. 해당하는 종류가 없으면 null.
  static OutingErrorType? fromResponse({
    required int? statusCode,
    required String message,
  }) {
    final trimmedMessage = message.trim();
    if (statusCode == _outingTimeNotAllowedStatusCode &&
        trimmedMessage == outingTimeNotAllowedMessage) {
      return OutingErrorType.outingTimeNotAllowed;
    }
    return null;
  }
}
