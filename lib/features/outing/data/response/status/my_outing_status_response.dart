import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/outing/ui/models/my_outing_status_model.dart';
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
    @Default('') String profileImageUrl,
    @Default('') String profileUrl,
  }) = _MyOutingStatusResponse;

  factory MyOutingStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$MyOutingStatusResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension MyOutingStatusResponseX on MyOutingStatusResponse {
  MyOutingStatusModel toModel() {
    final resolvedProfile = profileUrl.isNotEmpty ? profileUrl : profileImageUrl;

    return MyOutingStatusModel(
      memberId: memberId,
      status: status,
      name: name,
      grade: grade,
      department: department,
      lateCount: lateCount,
      profileImageUrl: resolvedProfile,
    );
  }
}
