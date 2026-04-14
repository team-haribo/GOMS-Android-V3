import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/widgets/bottom_sheets/common_bottom_sheet.dart';
import 'package:goms/features/member/presentation/widgets/member_filter_bottom_sheet.dart';

void main() {
  testWidgets(
    'MemberFilterBottomSheet keeps reset action close to bottom padding',
    (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: MemberFilterBottomSheet(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final sheetBottom = tester.getBottomLeft(find.byType(CommonBottomSheet)).dy;
    final resetBottom =
        tester.getBottomLeft(find.byType(GestureDetector).last).dy;

    expect(sheetBottom - resetBottom, lessThanOrEqualTo(28));
    },
  );
}
