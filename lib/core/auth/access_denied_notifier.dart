/// 학생회 전용 API가 최신 토큰으로도 403(권한 없음)을 돌려줬음을 세션 계층에
/// 알린다. (이슈 #150)
///
/// 권한이 회수된 뒤 토큰이 재발급되면 관리자 API가 403으로 거부되므로,
/// 이를 계기로 권한을 다시 조회해 화면에 반영한다.
typedef AccessDeniedCallback = void Function();

class AccessDeniedNotifier {
  AccessDeniedNotifier._();

  static AccessDeniedCallback? _callback;

  static void register(AccessDeniedCallback callback) {
    _callback = callback;
  }

  static void unregister(AccessDeniedCallback callback) {
    if (identical(_callback, callback)) {
      _callback = null;
    }
  }

  static void notify() {
    _callback?.call();
  }
}
