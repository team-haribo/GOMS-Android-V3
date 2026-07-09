import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

  test(
    'checkToken가 유효한 access token이 있어도 reissue를 먼저 호출해 권한을 최신화한다 (#123)',
    () async {
      final future = DateTime.now().toUtc().add(const Duration(days: 1));
      // 동기화 전 발급된, 아직 만료되지 않은 access token 상황을 재현한다.
      storage['access_token'] = 'stale-access-token';
      storage['access_token_expiry'] = future.toIso8601String();
      storage['refresh_token'] = 'valid-refresh-token';
      storage['refresh_token_expiry'] = future.toIso8601String();

      final session = _RecordingSessionDataSource();
      // 프로필은 stale(admin=학생회), /myrole은 서버 DB 기준 최신(user=학생).
      final repository = _FakeMemberRepository(
        profileRole: RoleEnum.admin,
        myRole: RoleEnum.user,
      );

      final container = ProviderContainer(
        overrides: [
          sessionRemoteDataSourceProvider.overrideWithValue(session),
          memberRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(authProvider.notifier).checkToken();

      expect(result, isTrue);
      // access token이 유효했음에도 재발급이 강제로 일어나야 한다.
      expect(session.reissueCalls, 1);
      expect(storage['access_token'], 'renewed-access-token');
      expect(storage['refresh_token'], 'renewed-refresh-token');
      expect(container.read(authProvider), AuthStatus.authenticated);
      // /myrole 값으로 stale 권한이 보정되어야 한다.
      expect(container.read(currentMemberProvider).value?.role, RoleEnum.user);
    },
  );
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
  _FakeMemberRepository({required this.profileRole, required this.myRole});

  final RoleEnum profileRole;
  final RoleEnum myRole;

  @override
  Future<CurrentMemberEntity> getMyProfile() async => CurrentMemberEntity(
        memberId: 1,
        email: 's24068@gsm.hs.kr',
        name: '이찬진',
        role: profileRole,
      );

  @override
  Future<RoleEnum> getMyRole() async => myRole;

  // 나머지 멤버는 이 테스트에서 사용하지 않으므로 noSuchMethod로 위임한다.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}
