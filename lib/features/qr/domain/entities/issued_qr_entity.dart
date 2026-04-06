class IssuedQrEntity {
  const IssuedQrEntity({
    required this.uuid,
    required this.exp,
    required this.issuedAt,
  });

  final String uuid;
  final int exp;
  final DateTime issuedAt;
}
