/// 토큰 재발급(reissue) 호출을 한 번에 하나씩만 실행되도록 직렬화한다.
///
/// 서버는 재발급 때마다 리프레시 토큰을 교체(rotation)한다. 인터셉터의 401 재발급과
/// 포그라운드 복귀 시의 권한 동기화 재발급이 같은 리프레시 토큰으로 동시에 나가면
/// 늦게 도착한 쪽이 이미 폐기된 토큰으로 거부(401/403)되어 세션이 끊길 수 있다.
/// 각 호출은 앞선 재발급이 끝난 뒤 저장소에서 최신 리프레시 토큰을 읽어 실행한다.
class TokenRefreshGate {
  TokenRefreshGate._();

  static Future<void> _tail = Future<void>.value();

  static Future<T> run<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }
}
