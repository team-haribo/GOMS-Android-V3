import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

part 'current_member_entity.freezed.dart';

@freezed
abstract class CurrentMemberEntity with _$CurrentMemberEntity {
  const factory CurrentMemberEntity({
    required int memberId,
    required String email,
    required String name,
    required RoleEnum role,
    @Default(0) int grade,
    @Default(DepartmentType.sw) DepartmentType department,
    @Default(GenderType.male) GenderType gender,
    @Default(OutingStatusType.coming) OutingStatusType status,
    @Default('') String profileImageUrl,
  }) = _CurrentMemberEntity;
}
