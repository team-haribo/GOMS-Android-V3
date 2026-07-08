import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum DepartmentType {
  @JsonValue('SW')
  sw('소프트웨어개발과'),

  @JsonValue('IOT')
  iot('스마트IoT과'),

  @JsonValue('AI')
  ai('인공지능과');

  const DepartmentType(this.label);

  final String label;
}
