import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/review/presentation/models/write_review_state.dart';

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
    required String placeName,
    required String category,
    required String address,
    required int review,
    required int recommended,
  }) async {
    if (!isFormValid) return;

    state = state.copyWith(status: WriteReviewStatus.loading);
    try {
      // TODO: 실제 후기 등록 API 호출
      await Future.delayed(const Duration(seconds: 1));

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
