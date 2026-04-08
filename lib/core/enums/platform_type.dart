import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PlatformType {
  @JsonValue('IOS')
  ios,

  @JsonValue('ANDROID')
  android,
}
