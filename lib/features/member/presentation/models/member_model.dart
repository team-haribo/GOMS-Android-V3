import 'package:flutter/foundation.dart';

@immutable
class MemberModel {
  const MemberModel({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.role,
    required this.profileImageUrl,
  });

  final int id;
  final String name;
  final String studentNumber;
  final String role;
  final String profileImageUrl;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MemberModel &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            studentNumber == other.studentNumber &&
            role == other.role &&
            profileImageUrl == other.profileImageUrl;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    studentNumber,
    role,
    profileImageUrl,
  );
}
