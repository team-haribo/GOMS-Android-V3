class QrRoutePath {
  const QrRoutePath._();

  static const String qr = '/qr';
  static const String qrIssue = '/qr/issue';
  static const String qrResult = '/qr/result/:resultType';

  static String qrResultLocation(String resultType) =>
      '/qr/result/$resultType';
}
