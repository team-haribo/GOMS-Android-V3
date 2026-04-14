import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_dto.g.dart';

@JsonSerializable()
class MemberDto {
  const MemberDto({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.role,
    required this.profileImageUrl,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) =>
      _$MemberDtoFromJson(json);

  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String studentNumber;

  @JsonKey(defaultValue: '')
  final String role;

  @JsonKey(defaultValue: '')
  final String profileImageUrl;

  Map<String, dynamic> toJson() => _$MemberDtoToJson(this);

  MemberEntity toEntity() {
    return MemberEntity(
      id: id,
      name: name,
      studentNumber: studentNumber,
      role: role,
      profileImageUrl: profileImageUrl,
    );
  }
}
