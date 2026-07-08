import 'package:freezed_annotation/freezed_annotation.dart';

part 'write_review_state.freezed.dart';

/// 후기 작성 상태
enum WriteReviewStatus {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 성공
  success,

  /// 실패
  failure,
}

/// 후기 작성 상태 모델
@freezed
abstract class WriteReviewState with _$WriteReviewState {
  const factory WriteReviewState({
    @Default(WriteReviewStatus.initial) WriteReviewStatus status,
    @Default('') String reviewText,
    String? errorMessage,
  }) = _WriteReviewState;

  /// 초기 상태
  factory WriteReviewState.initial() => const WriteReviewState();
}
