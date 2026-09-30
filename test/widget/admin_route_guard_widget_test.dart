import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/member/presentation/widgets/admin_route_guard_widget.dart';
import 'package:goms/features/outing/presentation/routes/outing_route_path.dart';

const _adminPath = '/admin';

const _admin = CurrentMemberEntity(
  memberId: 1,
  email: 's00000@gsm.hs.kr',
  name: '학생회',
  role: RoleEnum.admin,
);

void main() {
  late ProviderContainer container;

  Future<void> pumpGuard(
    WidgetTester tester,
    CurrentMemberEntity? member,
  ) async {
    container = ProviderContainer(
      overrides: [
        currentMemberProvider
            .overrideWith(() => _FakeCurrentMemberNotifier(member)),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: OutingRoutePath.home,
      routes: [
        GoRoute(
          path: OutingRoutePath.home,
          builder: (_, __) => const Scaffold(body: Text('home')),
        ),
        GoRoute(
          path: _adminPath,
          builder: (_, __) => const AdminRouteGuard(
            child: Scaffold(body: Text('admin')),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    router.push(_adminPath);
    await tester.pumpAndSettle();
  }

  void setMember(CurrentMemberEntity? member) {
    (container.read(currentMemberProvider.notifier)
            as _FakeCurrentMemberNotifier)
        .set(member);
  }

  testWidgets('권한이 학생으로 바뀌면 홈으로 이동하고 안내한다', (tester) async {
    await pumpGuard(tester, _admin);
    expect(find.text('admin'), findsOneWidget);

    setMember(_admin.copyWith(role: RoleEnum.user));
    await tester.pumpAndSettle();

    expect(find.text('admin'), findsNothing);
    expect(find.text('home'), findsOneWidget);
    expect(find.text('학생회 권한이 없어 홈으로 이동했어요.'), findsOneWidget);
  });

  testWidgets('권한이 없는 상태로 진입하면 바로 홈으로 이동한다', (tester) async {
    await pumpGuard(tester, _admin.copyWith(role: RoleEnum.user));

    expect(find.text('admin'), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('로그아웃으로 멤버가 비면 화면 이동을 세션 흐름에 맡긴다', (tester) async {
    await pumpGuard(tester, _admin);

    setMember(null);
    await tester.pumpAndSettle();

    expect(find.text('admin'), findsOneWidget);
  });
}

class _FakeCurrentMemberNotifier extends CurrentMemberNotifier {
  _FakeCurrentMemberNotifier(this._initial);

  final CurrentMemberEntity? _initial;

  @override
  Future<CurrentMemberEntity?> build() async => _initial;

  void set(CurrentMemberEntity? member) => state = AsyncData(member);
}
