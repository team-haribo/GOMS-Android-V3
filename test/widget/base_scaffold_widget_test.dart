import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';

void main() {
  testWidgets('BaseScaffold adds bottom system inset to body padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(
            padding: EdgeInsets.only(bottom: 32),
            viewPadding: EdgeInsets.only(bottom: 32),
          ),
          child: MaterialApp(
            home: BaseScaffold(
              showAppBar: false,
              body: SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );

    final padding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byType(BaseScaffold),
            matching: find.byType(Padding),
          )
          .first,
    );

    expect(
      padding.padding,
      const EdgeInsets.fromLTRB(24, 16, 24, 56),
    );
  });

  testWidgets('BaseScaffold does not keep bottom safe-area gap above keyboard',
      (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(
            viewPadding: EdgeInsets.only(bottom: 32),
            viewInsets: EdgeInsets.only(bottom: 300),
          ),
          child: MaterialApp(
            home: BaseScaffold(
              showAppBar: false,
              body: SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );

    final padding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byType(BaseScaffold),
            matching: find.byType(Padding),
          )
          .first,
    );

    expect(
      padding.padding,
      const EdgeInsets.fromLTRB(24, 16, 24, 24),
    );
  });

  testWidgets('BaseScaffold can opt out of keyboard-driven resizing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: BaseScaffold(
            showAppBar: false,
            resizeToAvoidBottomInset: false,
            body: SizedBox.shrink(),
          ),
        ),
      ),
    );

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

    expect(scaffold.resizeToAvoidBottomInset, isFalse);
  });
}
