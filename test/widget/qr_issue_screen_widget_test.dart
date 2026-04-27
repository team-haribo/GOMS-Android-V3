import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/qr/ui/models/issued_qr_model.dart';
import 'package:goms/features/qr/data/providers/qr_data_providers.dart';
import 'package:goms/features/qr/data/repositories/qr_repository.dart';
import 'package:goms/features/qr/ui/screens/qr_issue_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('QrIssueScreen matches the simplified QR layout for admin', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpScreen(tester);

    expect(find.text('외출 QR코드'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('QR코드 만료까지'), findsOneWidget);
    final countdownText = _findCountdownText(tester);
    expect(RegExp(r'0[45]분 [0-5][0-9]초').hasMatch(countdownText), isTrue);

    final countdown = tester.widget<Text>(find.text(countdownText));
    expect(countdown.style?.color, AppColors.admin);
  });

  testWidgets('QrIssueScreen reissues QR and resets countdown when re-entered',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _FakeQrRepository();

    await _pumpScreen(tester, repository: repository);
    expect(
      RegExp(r'0[45]분 [0-5][0-9]초').hasMatch(_findCountdownText(tester)),
      isTrue,
    );

    await tester.pump(const Duration(seconds: 2));
    expect(
      RegExp(r'0[45]분 [0-5][0-9]초').hasMatch(_findCountdownText(tester)),
      isTrue,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    await _pumpScreen(tester, repository: repository);

    expect(repository.issueCount, 2);
    expect(
      RegExp(r'0[45]분 [0-5][0-9]초').hasMatch(_findCountdownText(tester)),
      isTrue,
    );
  });

  testWidgets(
    'QrIssueScreen shows access message for non-admin',
    (tester) async {
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
    },
  );
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  QrRepository? repository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        roleProvider.overrideWith((ref) => RoleEnum.admin),
        qrRepositoryProvider
            .overrideWithValue(repository ?? _FakeQrRepository()),
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

class _FakeQrRepository implements QrRepository {
  int issueCount = 0;

  @override
  Future<IssuedQrModel> issueQr() async {
    issueCount += 1;
    final issuedAt = DateTime.now().add(Duration(seconds: issueCount));
    return IssuedQrModel(
      uuid: 'test-uuid-$issueCount',
      exp: issuedAt.add(const Duration(minutes: 5)).millisecondsSinceEpoch ~/
          1000,
      issuedAt: issuedAt,
    );
  }
}
