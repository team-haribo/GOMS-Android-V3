import 'package:flutter/foundation.dart';

@immutable
class IssuedQrModel {
  const IssuedQrModel({
    required this.uuid,
    required this.exp,
    required this.issuedAt,
  });

  final String uuid;
  final int exp;
  final DateTime issuedAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is IssuedQrModel &&
            runtimeType == other.runtimeType &&
            uuid == other.uuid &&
            exp == other.exp &&
            issuedAt == other.issuedAt;
  }

  @override
  int get hashCode => Object.hash(uuid, exp, issuedAt);
}
