import 'package:flutter_riverpod/legacy.dart';

final routeSheetVisibilityViewModelProvider =
    StateNotifierProvider.family<RouteSheetVisibilityViewModel, bool, String>(
  (ref, routeId) => RouteSheetVisibilityViewModel(),
);

class RouteSheetVisibilityViewModel extends StateNotifier<bool> {
  RouteSheetVisibilityViewModel() : super(false);

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}