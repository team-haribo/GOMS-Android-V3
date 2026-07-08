import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum OutingStatusType {
  @JsonValue('OUTING')
  outing,

  @JsonValue('COMING')
  coming,

  @JsonValue('CANNOT_OUTING')
  cannotOuting,
}
