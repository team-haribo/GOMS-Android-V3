import 'package:flutter_riverpod/legacy.dart';

class MapScreenUiState {
  final bool isSdkReady;
  final bool isFetchingRoute;

  const MapScreenUiState({
    this.isSdkReady = false,
    this.isFetchingRoute = false,
  });

  MapScreenUiState copyWith({
    bool? isSdkReady,
    bool? isFetchingRoute,
  }) {
    return MapScreenUiState(
      isSdkReady: isSdkReady ?? this.isSdkReady,
      isFetchingRoute: isFetchingRoute ?? this.isFetchingRoute,
    );
  }
}

final mapScreenProvider =
    StateNotifierProvider.autoDispose<MapScreenNotifier, MapScreenUiState>(
        (ref) {
  return MapScreenNotifier();
});

class MapScreenNotifier extends StateNotifier<MapScreenUiState> {
  MapScreenNotifier() : super(const MapScreenUiState());

  void setSdkReady(bool value) {
    state = state.copyWith(isSdkReady: value);
  }

  void setFetchingRoute(bool value) {
    state = state.copyWith(isFetchingRoute: value);
  }
}
