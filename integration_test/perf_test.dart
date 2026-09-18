import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:goms/app/router/app_router.dart' as app_router;
import 'package:goms/features/member/presentation/routes/member_route_path.dart';
import 'package:goms/features/outing/presentation/routes/outing_route_path.dart';
import 'package:goms/main.dart' as app;

late IntegrationTestWidgetsFlutterBinding binding;

/// 특정 시나리오만 돌리고 싶을 때: --dart-define=PERF_SCENARIOS=home_scroll,login
const _only = String.fromEnvironment('PERF_SCENARIOS');

String get _testEmail => dotenv.env['TEST_EMAIL'] ?? '';
String get _testPassword => dotenv.env['TEST_PASSWORD'] ?? '';

void main() {
  binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // app_startup 은 여기 없다. perfkit run 이 `flutter run --trace-startup` 으로
  // 따로 잰다 (integration_test 안에서는 이미 떠 있는 프로세스의 위젯 빌드
  // 시간(수 ms)일 뿐이라 콜드 스타트가 아니다).

  scenario(
    'login',
    (tester) async {
      await _enterText(tester, const Key('login_id'), _testEmail);
      await _enterText(tester, const Key('login_pw'), _testPassword);
      await tester.tap(find.byKey(const Key('login_submit')));
      // 로그인은 비동기 응답을 기다린다. pumpAndSettle 은 "예약된 프레임이 없으면"
      // 바로 반환하므로 화면 전환 전에 끝나버린다. 목표 위젯이 뜰 때까지 편다.
      await _pumpUntil(tester, find.byKey(const Key('home_list')));
    },
    // 스플래시 → 온보딩 → 로그인 화면 진입은 측정 대상(로그인 자체 성능)이
    // 아니라 setUp 에서 끝낸다.
    setUp: _goToLoginScreen,
  );

  scrollScenario('home_scroll', const Key('home_list'), setUp: _login);

  scrollScenario(
    'outing_state_scroll',
    const Key('outing_state_list'),
    setUp: (tester) async {
      await _login(tester);
      await _goTo(tester, OutingRoutePath.outingState);
    },
  );

  scrollScenario(
    'member_list_scroll',
    const Key('member_list'),
    setUp: (tester) async {
      await _login(tester);
      await _goTo(tester, MemberRoutePath.members);
    },
  );
}

/// 스크롤 시나리오. 측정 전에 같은 리스트를 2왕복 미리 굴린다 — 첫 스크롤은
/// 셰이더/이미지 캐시 워밍 때문에 항상 느려서 측정에 섞이면 노이즈만 커진다.
void scrollScenario(
  String name,
  Key list, {
  Future<void> Function(WidgetTester)? setUp,
}) {
  scenario(
    name,
    (tester) => _fling(tester, list, rounds: 10),
    setUp: (tester) async {
      await setUp?.call(tester);
      await _fling(tester, list, rounds: 2);
    },
  );
}

/// 시나리오 하나 = testWidgets 하나. traceAction 결과와 메타데이터를
/// `reportData` 에 시나리오 이름으로 넣어두면 driver 가 파일로 떨군다.
void scenario(
  String name,
  Future<void> Function(WidgetTester) body, {
  Future<void> Function(WidgetTester)? setUp,
}) {
  if (_only.isNotEmpty && !_only.split(',').contains(name)) return;

  testWidgets(name, (tester) async {
    app.main();
    await tester.pumpAndSettle();
    // setUp 은 측정 밖이다. 로그인/화면 진입과 워밍업이 여기서 끝난다.
    await setUp?.call(tester);
    await tester.pumpAndSettle();

    final wall = Stopwatch()..start();
    await binding.traceAction(() => body(tester), reportKey: 'timeline:$name');
    wall.stop();

    binding.reportData!['meta:$name'] = {
      'scenario': name,
      'duration_ms': wall.elapsedMilliseconds,
      'memory': {
        'rss_mb': ProcessInfo.currentRss / (1024 * 1024),
        'max_rss_mb': ProcessInfo.maxRss / (1024 * 1024),
      },
      'frame_budget_ms': 1000 /
          tester.view.display.refreshRate.clamp(30.0, 240.0),
    };
  });
}

/// 측정 구간이 짧으면 p95/p99 가 노이즈로 크게 흔들린다. 왕복 10회로 표본을 확보.
Future<void> _fling(WidgetTester tester, Key key, {required int rounds}) async {
  final target = find.byKey(key);
  for (var i = 0; i < rounds; i++) {
    await tester.fling(target, const Offset(0, -600), 4000);
    await tester.pumpAndSettle();
    await tester.fling(target, const Offset(0, 600), 4000);
    await tester.pumpAndSettle();
  }
}

/// 실기기(flutter drive)에서는 tester.enterText() 만 부르면 아무 것도 입력되지
/// 않는다 — showKeyboard() 가 실제 텍스트 입력 채널을 여는 건 필드가 먼저
/// 포커스돼 있을 때뿐이다. 반드시 tap 으로 먼저 포커스한 뒤 텍스트를 넣는다.
Future<void> _enterText(WidgetTester tester, Key key, String text) async {
  await tester.tap(find.byKey(key));
  await tester.pump();
  await tester.enterText(find.byKey(key), text);
  await tester.pump();
}

/// 앱은 스플래시 뒤 곧장 로그인 화면으로 가지 않고 온보딩을 먼저 보여준다
/// (토큰이 없으면 항상 온보딩 — CI 계정도 매번 이 경로를 탄다). 온보딩의
/// "로그인" 버튼을 눌러야 login_id 가 있는 화면에 도달한다.
Future<void> _goToLoginScreen(WidgetTester tester) async {
  await _pumpUntil(tester, find.byKey(const Key('onboarding_login_button')));
  await tester.tap(find.byKey(const Key('onboarding_login_button')));
  await tester.pumpAndSettle();
  await _pumpUntil(tester, find.byKey(const Key('login_id')));
}

Future<void> _login(WidgetTester tester) async {
  await _goToLoginScreen(tester);
  await _enterText(tester, const Key('login_id'), _testEmail);
  await _enterText(tester, const Key('login_pw'), _testPassword);
  await tester.tap(find.byKey(const Key('login_submit')));
  await _pumpUntil(tester, find.byKey(const Key('home_list')));
  await tester.pumpAndSettle();
}

/// 홈 셸 밖 화면(외출 현황·멤버 목록)은 별도 GoRoute 라 하단 탭 탭으로는 못 간다.
/// 실제 앱에서도 "더보기" 같은 버튼이 같은 router.go 를 호출하므로 라우팅·빌드
/// 성능은 동일하게 측정된다.
Future<void> _goTo(WidgetTester tester, String path) async {
  app_router.router.go(path);
  await tester.pumpAndSettle();
}

/// finder 가 나타날 때까지 프레임을 편다. 비동기 작업(네트워크 응답, 라우팅)은
/// 프레임을 예약하지 않는 구간이 있어서 pumpAndSettle 만으로는 못 기다린다.
Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 16));
    if (finder.evaluate().isNotEmpty) return;
  }
  // profile 빌드에서는 앱 로거가 꺼져 있어(kDebugMode 게이팅) 실패 원인을
  // 알 방법이 없다 — 화면에 실제로 뜬 텍스트를 그대로 찍어서 CI 로그에서
  // 바로 원인을 좁힐 수 있게 한다.
  final visibleTexts = tester
      .widgetList<Text>(find.byType(Text))
      .map((t) => t.data)
      .whereType<String>()
      .toList();
  debugPrint('[perfkit] timeout waiting for $finder, visible texts: $visibleTexts');
  throw StateError('timeout: $finder 를 기다리다 실패');
}
