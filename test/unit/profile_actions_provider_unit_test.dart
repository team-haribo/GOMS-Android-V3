import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/profile/presentation/providers/profile_actions_provider.dart';

void main() {
  ProviderContainer buildContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    // autoDispose 프로바이더가 await 사이에 버려지지 않게 구독을 잡아 둔다.
    final subscription = container.listen(profileActionsProvider, (_, __) {});
    addTearDown(subscription.close);
    return container;
  }

  test('로그인 멤버 이메일이 없으면 인증 메일을 보내지 않고 실패로 끝난다', () async {
    final container = buildContainer();
    // 멤버 정보가 없는 상태(AsyncData(null))로 확정시킨다.
    await container.read(currentMemberProvider.future);

    final result = await container
        .read(profileActionsProvider.notifier)
        .startPasswordReset();

    expect(result.ok, isFalse);
    expect(result.message, '이메일 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
  });

  test('이미 기본 프로필이면 삭제 요청 없이 안내만 돌려준다', () async {
    final container = buildContainer();
    // 프로필 이미지가 없는 상태(AsyncData(null))로 확정시킨다.
    await container.read(currentMemberProvider.future);

    final result = await container
        .read(profileActionsProvider.notifier)
        .deleteProfileImage();

    expect(result?.ok, isFalse);
    expect(result?.message, '이미 기본 프로필을 사용 중이에요.');
    // 네트워크를 타지 않았으므로 진행 중 플래그가 남지 않는다.
    expect(container.read(profileActionsProvider), isFalse);
  });
}
