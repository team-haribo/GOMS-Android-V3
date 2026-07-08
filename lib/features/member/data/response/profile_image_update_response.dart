import 'package:json_annotation/json_annotation.dart';

part 'profile_image_update_response.g.dart';

@JsonSerializable()
class ProfileImageUpdateResponse {
  const ProfileImageUpdateResponse({required this.imageUrl});

  factory ProfileImageUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageUpdateResponseFromJson(json);

  @JsonKey(defaultValue: '')
  final String imageUrl;

  Map<String, dynamic> toJson() => _$ProfileImageUpdateResponseToJson(this);
}
