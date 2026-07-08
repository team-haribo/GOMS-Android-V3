import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/utils/logger.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

part 'current_member_dto.g.dart';

@JsonSerializable()
class CurrentMemberDto {
  const CurrentMemberDto({
    required this.memberId,
    required this.email,
    required this.name,
    required this.role,
    required this.grade,
    required this.department,
    required this.gender,
    required this.status,
    required this.profileImageUrl,
  });

  factory CurrentMemberDto.fromJson(Map<String, dynamic> json) =>
      _$CurrentMemberDtoFromJson(json);

  @JsonKey(defaultValue: 0)
  final int memberId;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(fromJson: RoleEnum.fromServer, toJson: _roleEnumToJson)
  final RoleEnum role;
  @JsonKey(defaultValue: 0)
  final int grade;
  @JsonKey(
    defaultValue: DepartmentType.sw,
    unknownEnumValue: DepartmentType.sw,
  )
  final DepartmentType department;
  @JsonKey(
    defaultValue: GenderType.male,
    unknownEnumValue: GenderType.male,
  )
  final GenderType gender;
  @JsonKey(
    defaultValue: OutingStatusType.coming,
    unknownEnumValue: OutingStatusType.coming,
  )
  final OutingStatusType status;
  @JsonKey(fromJson: _profileImageUrlFromJson, toJson: _stringToJson)
  final String profileImageUrl;

  CurrentMemberEntity toEntity() {
    return CurrentMemberEntity(
      memberId: memberId,
      email: email,
      name: name,
      role: role,
      grade: grade,
      department: department,
      gender: gender,
      status: status,
      profileImageUrl: profileImageUrl,
    );
  }

  Map<String, dynamic> toJson() => _$CurrentMemberDtoToJson(this);

  static String _roleEnumToJson(RoleEnum role) {
    return role.toServer();
  }

  static String _profileImageUrlFromJson(Object? value) {
    if (value is Map<String, dynamic>) {
      final resolved = value['profileImageUrl'] ?? value['profileUrl'];
      if (resolved == null) {
        return '';
      }
      if (resolved is String) {
        return resolved;
      }

      Logger.e(
        'CurrentMemberDto profile image field has unexpected type: ${resolved.runtimeType}',
        tag: 'MEMBER',
      );
      return '';
    }

    if (value == null) {
      return '';
    }
    if (value is String) {
      return value;
    }

    Logger.e(
      'CurrentMemberDto profile image payload has unexpected type: ${value.runtimeType}',
      tag: 'MEMBER',
    );
    return '';
  }

  static String _stringToJson(String value) => value;
}
