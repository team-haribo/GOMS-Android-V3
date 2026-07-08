import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ReportStatus {
  @JsonValue('PENDING')
  pending,

  @JsonValue('APPROVED')
  approved,

  @JsonValue('REJECTED')
  rejected,
}
