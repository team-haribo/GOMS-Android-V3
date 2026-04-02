import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GenderType {
  @JsonValue('MALE')
  male('남자'),

  @JsonValue('FEMALE')
  female('여자');

  const GenderType(this.label);

  final String label;
}
