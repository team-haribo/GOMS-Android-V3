import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/auth/access_denied_notifier.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/auth/session/data/datasources/session_remote_datasource.dart';
import 'package:goms/features/auth/session/data/providers/session_data_providers.dart';
import 'package:goms/features/auth/session/data/request/signin/signin_request_dto.dart';
import 'package:goms/features/auth/session/data/response/signin/signin_response_dto.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  final storage = <String, String?>{};

  Future<Object?> secureStorageHandler(MethodCall call) async {
    final arguments = Map<String, dynamic>.from(
      (call.arguments as Map?)?.cast<String, dynamic>() ?? const {},
    );
    final key = arguments['key'] as String?;
    switch (call.method) {
      case 'read':
        return storage[key];
      case 'write':
        if (key != null) storage[key] = arguments['value'] as String?;
        return null;
      case 'delete':
        if (key != null) storage.remove(key);
        return null;
      case 'deleteAll':
        storage.clear();
        return null;
      default:
        return null;
    }
  }

  setUp(() {
    storage.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, secureStorageHandler);
  });

  tearDown(() {
    storage.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

  late _RecordingSessionDataSource session;
  late _FakeMemberRepository repository;
  late ProviderContainer container;

  void saveTokens({required bool accessTokenValid}) {
    final now = DateTime.now().toUtc();
    final future = now.add(const Duration(days: 1));
    storage['access_token'] = 'access-token';
    storage['access_token_expiry'] =
        (accessTokenValid ? future : now.subtract(const Duration(minutes: 1)))
            .toIso8601String();
    storage['refresh_token'] = 'valid-refresh-token';
    storage['refresh_token_expiry'] = future.toIso8601String();
  }

  setUp(() {
    session = _RecordingSessionDataSource();
    repository = _FakeMemberRepository(role: RoleEnum.admin);
    container = ProviderContainer(
      overrides: [
        sessionRemoteDataSourceProvider.overrideWithValue(session),
        memberRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  group('checkToken', () {
    test('access token이 유효하면 재발급 없이 프로필로 권한을 불러온다', () async {
      saveTokens(accessTokenValid: true);

      final result = await container.read(authProvider.notifier).checkToken();

      expect(result, isTrue);
      expect(session.reissueCalls, 0);
      expect(storage['access_token'], 'access-token');
      expect(container.read(currentMemberProvider).value?.role, RoleEnum.admin);
      expect(container.read(authProvider), AuthStatus.authenticated);
    });

    test('access token이 만료됐으면 재발급 후 세션을 불러온다', () async {
      saveTokens(accessTokenValid: false);

      final result = await container.read(authProvider.notifier).checkToken();

      expect(result, isTrue);
      expect(session.reissueCalls, 1);
      expect(storage['access_token'], 'renewed-access-token');
      expect(container.read(authProvider), AuthStatus.authenticated);
    });
  });

  test('refreshProfile는 await 도중 세션이 종료되면 세션을 부활시키지 않는다', () async {
    await container.read(currentMemberProvider.notifier).fetch();
    expect(container.read(currentMemberProvider).value, isNotNull);

    // 프로필 응답 직전에 로그아웃(clear)이 일어난 상황을 재현한다.
    repository.onGetMyProfile = () async {
      container.read(currentMemberProvider.notifier).clear();
    };
    await container.read(currentMemberProvider.notifier).refreshProfile();

    expect(container.read(currentMemberProvider).value, isNull);
  });

  test('refreshProfile는 await 도중 바뀐 프로필 사진을 되돌리지 않고 role만 반영한다', () async {
    await container.read(currentMemberProvider.notifier).fetch();

    // 조회 응답 직전에 프로필 사진이 바뀌고, 서버 DB 권한도 바뀐 상황을 재현한다.
    repository.role = RoleEnum.user;
    repository.onGetMyProfile = () async {
      container
          .read(currentMemberProvider.notifier)
          .updateProfileImageUrl('new-image-url');
    };
    final refreshed =
        await container.read(currentMemberProvider.notifier).refreshProfile();

    final member = container.read(currentMemberProvider).value;
    expect(refreshed, isTrue);
    expect(member?.profileImageUrl, 'new-image-url');
    expect(member?.role, RoleEnum.user);
  });

  test('refreshProfile는 같은 계정으로 재로그인한 뒤 도착한 이전 세션 응답을 버린다', () async {
    final notifier = container.read(currentMemberProvider.notifier);
    await notifier.fetch();

    repository.onGetMyProfile = () async {
      repository.onGetMyProfile = null;
      // 이전 요청의 응답 대기 중 로그아웃 후 같은 계정으로 재로그인. 새 세션은 학생 권한.
      notifier.clear();
      repository.role = RoleEnum.user;
      await notifier.fetch();
      // 이전 요청의 응답은 예전 권한(학생회)을 담고 있다.
      repository.role = RoleEnum.admin;
    };
    final refreshed = await notifier.refreshProfile();

    expect(refreshed, isFalse);
    expect(container.read(currentMemberProvider).value?.role, RoleEnum.user);
  });

  group('syncRole (#146)', () {
    setUp(() => saveTokens(accessTokenValid: true));

    test('앱 실행 중 회수된 권한을 재발급 없이 프로필 재조회로 반영한다', () async {
      final auth = container.read(authProvider.notifier);
      await auth.setAuthenticated();
      expect(container.read(currentMemberProvider).value?.role, RoleEnum.admin);

      // 앱을 켜 둔 동안 서버 DB에서 권한이 회수됨.
      repository.role = RoleEnum.user;
      await auth.syncRole(force: true);

      expect(session.reissueCalls, 0);
      expect(container.read(currentMemberProvider).value?.role, RoleEnum.user);
      expect(container.read(authProvider), AuthStatus.authenticated);
    });

    test('최소 간격 안의 반복 복귀와 동시 호출은 한 번만 조회한다', () async {
      final auth = container.read(authProvider.notifier);
      await auth.setAuthenticated();
      final callsAfterLogin = repository.profileCalls;

      await Future.wait([
        auth.syncRole(force: true),
        auth.syncRole(force: true),
      ]);
      await auth.syncRole();

      expect(repository.profileCalls, callsAfterLogin + 1);
    });

    test('당겨서 새로고침(force)은 최소 간격과 관계없이 바로 반영한다', () async {
      final auth = container.read(authProvider.notifier);
      await auth.checkToken();

      // 방금 동기화한 직후에 권한이 바뀜.
      repository.role = RoleEnum.user;
      await auth.syncRole();
      expect(container.read(currentMemberProvider).value?.role, RoleEnum.admin);

      await auth.syncRole(force: true);

      expect(container.read(currentMemberProvider).value?.role, RoleEnum.user);
    });

    test('API가 403으로 거부하면 최소 간격과 관계없이 권한을 다시 조회한다 (#150)', () async {
      final auth = container.read(authProvider.notifier);
      await auth.setAuthenticated();

      // 로그인 직후(최소 간격 안)에 권한이 회수되고 관리자 API가 403을 받음.
      repository.role = RoleEnum.user;
      AccessDeniedNotifier.notify();
      await pumpEventQueue();

      expect(container.read(currentMemberProvider).value?.role, RoleEnum.user);
    });

    test('로그인 직후 첫 복귀는 프로필을 다시 조회하지 않는다', () async {
      final auth = container.read(authProvider.notifier);
      await auth.setAuthenticated();
      final callsAfterLogin = repository.profileCalls;

      expect(await auth.syncRole(), isTrue);

      expect(repository.profileCalls, callsAfterLogin);
    });

    test('조회에 실패하면 최소 간격과 관계없이 다음 복귀 때 다시 시도한다', () async {
      final auth = container.read(authProvider.notifier);
      await auth.setAuthenticated();

      repository.failProfile = true;
      expect(await auth.syncRole(force: true), isFalse);
      expect(container.read(currentMemberProvider).value?.role, RoleEnum.admin);

      repository.failProfile = false;
      repository.role = RoleEnum.user;
      expect(await auth.syncRole(), isTrue);

      expect(container.read(currentMemberProvider).value?.role, RoleEnum.user);
    });

    test('최소 간격 때문에 건너뛴 경우는 실패로 보지 않는다', () async {
      final auth = container.read(authProvider.notifier);
      await auth.checkToken();

      repository.failProfile = true;
      expect(await auth.syncRole(), isTrue);
      expect(repository.profileCalls, 1);
    });

    test('로그아웃 전에 시작한 동기화는 새 세션과 공유하지 않는다', () async {
      final auth = container.read(authProvider.notifier);
      await auth.setAuthenticated();

      final gate = Completer<void>();
      repository.onGetMyProfile = () => gate.future;
      final oldSync = auth.syncRole(force: true);
      repository.onGetMyProfile = null;

      // 이전 요청이 끝나기 전에 로그아웃 후 재로그인.
      await auth.logout();
      await auth.setAuthenticated();
      final callsBeforeNewSync = repository.profileCalls;

      final newSync = auth.syncRole(force: true);
      expect(identical(newSync, oldSync), isFalse);
      expect(repository.profileCalls, callsBeforeNewSync + 1);

      gate.complete();
      // 이전 세션의 결과는 새 세션에 실패로 알리지 않는다.
      expect(await oldSync, isTrue);
      expect(await newSync, isTrue);
      expect(container.read(authProvider), AuthStatus.authenticated);
    });

    test('인증되지 않은 상태에서는 아무것도 하지 않는다', () async {
      await container.read(authProvider.notifier).syncRole();

      expect(repository.profileCalls, 0);
      expect(container.read(currentMemberProvider).value, isNull);
    });
  });
}

class _RecordingSessionDataSource implements SessionRemoteDataSource {
  int reissueCalls = 0;

  @override
  Future<SignInResponseDto> reissue(String refreshToken) async {
    reissueCalls++;
    final future = DateTime.now().toUtc().add(const Duration(days: 1));
    return SignInResponseDto(
      accessToken: 'renewed-access-token',
      refreshToken: 'renewed-refresh-token',
      accessTokenExpiresIn: future,
      refreshTokenExpiresIn: future,
    );
  }

  @override
  Future<SignInResponseDto> signIn(SignInRequestDto requestDto) =>
      throw UnimplementedError();

  @override
  Future<void> signOut(String refreshToken) => throw UnimplementedError();
}

class _FakeMemberRepository implements MemberRepository {
  _FakeMemberRepository({required this.role});

  /// 앱 실행 중 서버 DB의 권한이 바뀌는 상황을 재현할 수 있도록 변경 가능하게 둔다.
  RoleEnum role;

  int profileCalls = 0;

  /// true면 프로필 조회가 실패한다.
  bool failProfile = false;

  /// getMyProfile의 await 도중 상태를 바꾸기 위한 훅.
  Future<void> Function()? onGetMyProfile;

  @override
  Future<CurrentMemberEntity> getMyProfile() async {
    profileCalls++;
    if (failProfile) {
      throw Exception('profile failed');
    }
    await onGetMyProfile?.call();
    return CurrentMemberEntity(
      memberId: 1,
      email: 's24068@gsm.hs.kr',
      name: '이찬진',
      role: role,
    );
  }

  // 나머지 멤버는 이 테스트에서 사용하지 않으므로 noSuchMethod로 위임한다.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}
