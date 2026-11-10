import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/outing/domain/enums/outing_error_type.dart';

void main() {
  group('OutingErrorType.fromResponse', () {
    test('403 + 외출 시간 제한 문구면 outingTimeNotAllowed를 반환한다', () {
      expect(
        OutingErrorType.fromResponse(
          statusCode: 403,
          message: ' 외출 가능 시간이 아닙니다. ',
        ),
        OutingErrorType.outingTimeNotAllowed,
      );
    });

    test('문구가 같아도 status가 다르면 null을 반환한다', () {
      expect(
        OutingErrorType.fromResponse(
          statusCode: 400,
          message: '외출 가능 시간이 아닙니다.',
        ),
        isNull,
      );
    });

    test('같은 403이어도 문구가 다르면 null을 반환한다', () {
      expect(
        OutingErrorType.fromResponse(
          statusCode: 403,
          message: '외출이 금지된 사용자입니다.',
        ),
        isNull,
      );
    });
  });
}
