import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_screen_provider.freezed.dart';

@freezed
abstract class MapScreenUiState with _$MapScreenUiState {
  const factory MapScreenUiState({
    @Default(false) bool isSdkReady,
    @Default(false) bool isFetchingRoute,
  }) = _MapScreenUiState;
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
