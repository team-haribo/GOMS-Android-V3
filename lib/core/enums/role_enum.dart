import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum RoleEnum {
  @JsonValue('ROLE_STUDENT_COUNCIL')
  admin,

  @JsonValue('ROLE_STUDENT')
  user;

  static RoleEnum fromServer(String? value) {
    switch (value) {
      case 'ROLE_STUDENT_COUNCIL':
      case 'ROLE_ADMIN':
        return RoleEnum.admin;
      case 'ROLE_STUDENT':
      default:
        return RoleEnum.user;
    }
  }

  String toServer() {
    switch (this) {
      case RoleEnum.admin:
        return 'ROLE_STUDENT_COUNCIL';
      case RoleEnum.user:
        return 'ROLE_STUDENT';
    }
  }
}
