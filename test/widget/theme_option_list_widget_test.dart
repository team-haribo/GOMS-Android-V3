import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/profile/presentation/widgets/theme_setting_item.dart';
import 'package:goms_design_system/goms_design_system.dart';

import '../test_app.dart';

void main() {
  Widget buildItem({
    required AppThemeOption selected,
    required ValueChanged<AppThemeOption> onSelected,
  }) {
    return buildTestApp(
      ThemeSettingItem(selected: selected, onSelected: onSelected),
    );
  }

  testWidgets('테마 목록은 접혀 있다가 헤더를 누르면 펼쳐진다', (tester) async {
    await tester.pumpWidget(
      buildItem(selected: AppThemeOption.system, onSelected: (_) {}),
    );

    // 접힌 상태: 트리거에 현재 테마만 보이고 나머지 선택지는 없다.
    expect(find.text(AppThemeOption.system.label), findsOneWidget);
    expect(find.text(AppThemeOption.dark.label), findsNothing);
    expect(find.text(AppThemeOption.light.label), findsNothing);

    await tester.tap(find.text(AppThemeOption.system.label));
    await tester.pumpAndSettle();

    // 펼친 상태: 트리거 + 목록에 각각 하나씩.
    expect(find.text(AppThemeOption.system.label), findsNWidgets(2));
    expect(find.text(AppThemeOption.dark.label), findsOneWidget);
    expect(find.text(AppThemeOption.light.label), findsOneWidget);
  });

  testWidgets('선택된 항목은 메인 컬러로 표시되고 다른 항목을 누르면 콜백이 온다', (tester) async {
    AppThemeOption? picked;
    await tester.pumpWidget(
      buildItem(
        selected: AppThemeOption.system,
        onSelected: (option) => picked = option,
      ),
    );

    await tester.tap(find.text(AppThemeOption.system.label));
    await tester.pumpAndSettle();

    // 목록 안의 '시스템 테마 설정'(두 번째)이 선택 상태 색을 쓴다.
    final selectedText =
        tester.widgetList<Text>(find.text(AppThemeOption.system.label)).last;
    expect(selectedText.style?.color, AppColors.mainColor);

    await tester.tap(find.text(AppThemeOption.light.label));
    await tester.pumpAndSettle();

    expect(picked, AppThemeOption.light);
  });
}
