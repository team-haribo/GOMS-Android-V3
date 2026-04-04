import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';
import 'package:goms/features/qr/presentation/providers/issued_qr_provider.dart';
import 'package:goms/features/qr/presentation/screens/qr_issue_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('QrIssueScreen renders centered QR with countdown for admin', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpScreen(tester);

    expect(find.byType(QrImageView), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byType(QrImageView),
        matching: find.byType(Center),
      ),
      findsWidgets,
    );
    expect(find.text('QR 만료까지'), findsOneWidget);

    final countdownText = _findCountdownText(tester);
    expect(RegExp(r'0[45]분 [0-5][0-9]초').hasMatch(countdownText), isTrue);
  });

  testWidgets('QrIssueScreen shows access message for non-admin', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
        ],
        child: MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
              Breakpoint(
                start: 1921,
                end: double.infinity,
                name: AppBreakpoints.largeDesktop,
              ),
            ],
          ),
          home: const QrIssueScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('학생회만 QR을 발급할 수 있어요.'), findsOneWidget);
    expect(find.byType(QrImageView), findsNothing);
  });
}

Future<void> _pumpScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        roleProvider.overrideWith((ref) => RoleEnum.admin),
        issuedQrProvider.overrideWith(_FakeIssuedQrNotifier.new),
      ],
      child: MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
            Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
            Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
            Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
            Breakpoint(
              start: 1921,
              end: double.infinity,
              name: AppBreakpoints.largeDesktop,
            ),
          ],
        ),
        home: const QrIssueScreen(),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

String _findCountdownText(WidgetTester tester) {
  return tester
      .widgetList<Text>(find.byType(Text))
      .map((widget) => widget.data)
      .whereType<String>()
      .firstWhere((text) => RegExp(r'\d{2}분 \d{2}초').hasMatch(text));
}

class _FakeIssuedQrNotifier extends IssuedQrNotifier {
  @override
  Future<IssuedQrEntity> build() async {
    final now = DateTime.now();
    return IssuedQrEntity(
      uuid: 'test-uuid',
      exp: now.add(const Duration(minutes: 10)).millisecondsSinceEpoch ~/ 1000,
      issuedAt: now,
    );
  }
}
