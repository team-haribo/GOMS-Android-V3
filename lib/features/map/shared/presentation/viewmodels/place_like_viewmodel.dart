import 'package:flutter_riverpod/flutter_riverpod.dart';

final placeLikeViewModelProvider =
    StateNotifierProvider.family<PlaceLikeViewModel, bool, String>(
  (ref, placeId) => PlaceLikeViewModel(initialState: false),
);

class PlaceLikeViewModel extends StateNotifier<bool> {
  PlaceLikeViewModel({required bool initialState}) : super(initialState);

  void toggle() {
    state = !state;
  }

  void setLike(bool isLiked) {
    state = isLiked;
  }
}
