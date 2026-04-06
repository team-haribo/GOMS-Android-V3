import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

part 'my_outing_status_response.freezed.dart';
part 'my_outing_status_response.g.dart';

@freezed
abstract class MyOutingStatusResponse with _$MyOutingStatusResponse {
  const factory MyOutingStatusResponse({
    required int memberId,
    required OutingStatusType status,
    required String name,
    required int grade,
    required String department,
    required int lateCount,
  }) = _MyOutingStatusResponse;

  factory MyOutingStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$MyOutingStatusResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension MyOutingStatusResponseX on MyOutingStatusResponse {
  MyOutingStatusEntity toEntity() {
    return MyOutingStatusEntity(
      memberId: memberId,
      status: status,
      name: name,
      grade: grade,
      department: department,
      lateCount: lateCount,
    );
  }
}
