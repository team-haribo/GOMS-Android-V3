import 'package:flutter_riverpod/flutter_riverpod.dart';

final routeSheetVisibilityViewModelProvider =
    NotifierProvider.family<RouteSheetVisibilityNotifier, bool, String>(
  (_) => RouteSheetVisibilityNotifier(),
);

class RouteSheetVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void open() => state = true;
  void close() => state = false;
  void toggle() => state = !state;
}
