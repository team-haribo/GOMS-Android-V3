import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/presentation/providers/map_screen_provider.dart';
import 'package:goms/features/map/review/presentation/models/write_review_state.dart';

final writeReviewViewModelProvider =
    NotifierProvider<WriteReviewViewModel, WriteReviewState>(
  WriteReviewViewModel.new,
);

class WriteReviewViewModel extends Notifier<WriteReviewState> {
  static const int maxLength = 100;

  late final TextEditingController controller;

  @override
  WriteReviewState build() {
    controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return WriteReviewState.initial();
  }

  void onTextChanged(String text) {
    state = state.copyWith(reviewText: text);
  }

  bool get isFormValid => state.reviewText.trim().isNotEmpty;

  Future<void> submitReview({
    required int? placeId,
    required String placeName,
    required String category,
    required String address,
    required int review,
    required int recommended,
  }) async {
    if (!isFormValid) return;

    state = state.copyWith(status: WriteReviewStatus.loading);
    try {
      if (placeId == null) {
        throw Exception('장소 정보가 올바르지 않습니다.');
      }

      await ref.read(recommendedPlaceRepositoryProvider).createReview(
            placeId: placeId,
            content: state.reviewText.trim(),
          );

      ref.invalidate(placeDetailProvider(placeId));
      ref.invalidate(placeReviewsProvider(placeId));
      ref.invalidate(myReviewIdsProvider);
      ref.invalidate(allPlacesProvider);
      ref.invalidate(recommendedPlacesProvider);
      ref.invalidate(recommendedPlacesCountProvider);

      await ref.read(mapScreenProvider.notifier).fetchData();

      state = state.copyWith(status: WriteReviewStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: WriteReviewStatus.failure,
        errorMessage: '후기 등록에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      status: WriteReviewStatus.initial,
      errorMessage: null,
    );
  }

  void reset() {
    controller.clear();
    state = WriteReviewState.initial();
  }
}