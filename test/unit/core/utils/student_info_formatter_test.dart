import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/utils/student_info_formatter.dart';

void main() {
  group('StudentInfoFormatter', () {
    test('formats grade as cohort and department with 과 suffix', () {
      expect(
        StudentInfoFormatter.formatCohortDepartment(
          grade: 9,
          department: 'SW',
        ),
        '9기 | SW과',
      );
    });

    test('does not duplicate department suffix', () {
      expect(
        StudentInfoFormatter.formatCohortDepartment(
          grade: 8,
          department: 'AI과',
        ),
        '8기 | AI과',
      );
    });
  });
}
