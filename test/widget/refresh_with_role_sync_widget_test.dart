import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/auth/session/presentation/utils/refresh_with_role_sync.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';

void main() {
  const failureMessage = '최신 정보를 불러오지 못했어요. 잠시 후 다시 시도해주세요.';

  Future<void> pumpAndRefresh(
    WidgetTester tester, {
    required bool synced,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(synced: synced)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => refreshWithRoleSync(context, ref, [
                  Future<void>.value(),
                ]),
                child: const Text('refresh'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('refresh'));
    await tester.pumpAndSettle();
  }

  testWidgets('권한 조회에 실패하면 스낵바로 알린다 (#146)', (tester) async {
    await pumpAndRefresh(tester, synced: false);

    expect(find.text(failureMessage), findsOneWidget);
  });

  testWidgets('권한 조회에 성공하면 스낵바를 띄우지 않는다 (#146)', (tester) async {
    await pumpAndRefresh(tester, synced: true);

    expect(find.text(failureMessage), findsNothing);
  });
}

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier({required this.synced});

  final bool synced;

  @override
  AuthStatus build() => AuthStatus.authenticated;

  @override
  Future<bool> syncRole({bool force = false}) async => synced;
}
