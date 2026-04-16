typedef SessionExpiredCallback = Future<void> Function();

class SessionExpiryNotifier {
  SessionExpiryNotifier._();

  static SessionExpiredCallback? _callback;

  static void register(SessionExpiredCallback callback) {
    _callback = callback;
  }

  static void unregister(SessionExpiredCallback callback) {
    if (identical(_callback, callback)) {
      _callback = null;
    }
  }

  static Future<void> notify() async {
    final callback = _callback;
    if (callback == null) {
      return;
    }
    await callback();
  }
}
