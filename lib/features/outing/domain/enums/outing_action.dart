import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum OutingAction {
  @JsonValue('OUT')
  out,

  @JsonValue('IN')
  inAction,
}
