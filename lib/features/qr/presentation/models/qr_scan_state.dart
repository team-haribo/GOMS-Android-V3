enum QrScanStatus { idle, processing, success, failure }

enum QrScanResultType {
  outingStarted,
  returnSuccess,
  lateReturn,
  cannotGoOut,
}

class QrScanState {
  const QrScanState({
    required this.status,
    this.resultType,
    this.errorMessage,
    this.failureScreenMessage,
  });

  const QrScanState.idle()
      : this(status: QrScanStatus.idle, resultType: null, errorMessage: null);

  const QrScanState.processing()
      : this(
          status: QrScanStatus.processing,
          resultType: null,
          errorMessage: null,
        );

  const QrScanState.success(QrScanResultType resultType)
      : this(
          status: QrScanStatus.success,
          resultType: resultType,
          errorMessage: null,
        );

  const QrScanState.failure(
    String errorMessage, {
    String? failureScreenMessage,
  }) : this(
          status: QrScanStatus.failure,
          resultType: null,
          errorMessage: errorMessage,
          failureScreenMessage: failureScreenMessage,
        );

  final QrScanStatus status;
  final QrScanResultType? resultType;
  final String? errorMessage;

  /// 실패 화면 부제에 그대로 보여줄 서버 메시지.
  /// null이면 실패 화면은 기본 문구를 보여준다.
  final String? failureScreenMessage;

  bool get isProcessing => status == QrScanStatus.processing;
}
