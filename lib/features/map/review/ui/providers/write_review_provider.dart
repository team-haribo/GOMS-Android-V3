import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/providers/recommended_place_providers.dart';
import 'package:goms/features/map/discovery/ui/providers/map_screen_provider.dart';
import 'package:goms/features/map/review/ui/models/write_review_state.dart';

/// 후기 작성 Provider
final writeReviewProvider =
    NotifierProvider<WriteReviewNotifier, WriteReviewState>(
  WriteReviewNotifier.new,
);

/// 후기 작성 Notifier
class WriteReviewNotifier extends Notifier<WriteReviewState> {
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

  // ==================== 유효성 검사 ====================

  /// 텍스트 변경 처리
  void onTextChanged(String text) {
    state = state.copyWith(reviewText: text);
  }

  /// 폼 유효성 여부
  bool get isFormValid => state.reviewText.trim().isNotEmpty;

  // ==================== Actions ====================

  /// 후기 등록 제출
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
      ref.invalidate(mapScreenProvider);
      ref.invalidate(placeDetailProvider(placeId));
      ref.invalidate(placeReviewsProvider(placeId));
      ref.invalidate(myReviewIdsProvider);

      state = state.copyWith(status: WriteReviewStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: WriteReviewStatus.failure,
        errorMessage: '후기 등록에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(
      status: WriteReviewStatus.initial,
      errorMessage: null,
    );
  }

  /// 상태 초기화
  void reset() {
    controller.clear();
    state = WriteReviewState.initial();
  }
}
