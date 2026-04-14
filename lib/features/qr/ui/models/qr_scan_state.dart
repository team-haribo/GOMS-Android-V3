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

  const QrScanState.failure(String errorMessage)
      : this(
          status: QrScanStatus.failure,
          resultType: null,
          errorMessage: errorMessage,
        );

  final QrScanStatus status;
  final QrScanResultType? resultType;
  final String? errorMessage;

  bool get isProcessing => status == QrScanStatus.processing;
}
