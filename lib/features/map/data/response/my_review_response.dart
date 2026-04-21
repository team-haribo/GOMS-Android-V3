import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/map/domain/entities/my_review_entity.dart';

part 'my_review_response.freezed.dart';
part 'my_review_response.g.dart';

@Freezed(fromJson: true, toJson: false)
abstract class MyReviewResponse with _$MyReviewResponse {
  const MyReviewResponse._();

  const factory MyReviewResponse({
    required int reviewId,
    required int placeId,
    required String placeName,
    required String categoryName,
    required String address,
    required String content,
    required DateTime? reviewedAt,
  }) = _MyReviewResponse;

  factory MyReviewResponse.fromJson(Map<String, dynamic> json) {
    return _$MyReviewResponseFromJson(
      <String, dynamic>{
        ...json,
        'reviewId': _toInt(json['reviewId']),
        'placeId': _toInt(json['placeId']),
        'placeName': _toString(json['placeName']),
        'categoryName': _toString(json['categoryName']),
        'address': _toString(json['address']),
        'content': _toString(json['content']),
        'reviewedAt': _toDateTimeString(json['reviewedAt']),
      },
    );
  }

  MyReviewEntity toEntity() {
    return MyReviewEntity(
      reviewId: reviewId,
      placeId: placeId,
      placeName: placeName,
      categoryName: categoryName,
      address: address,
      content: content,
      reviewedAt: _normalizeDateTime(reviewedAt),
    );
  }
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse('$value') ?? 0;
}

String _toString(Object? value) => value as String? ?? '';

DateTime? _toNullableDateTime(Object? value) {
  final raw = value as String?;
  if (raw == null || raw.isEmpty) {
    return null;
  }

  final parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    return null;
  }

  return parsed.isUtc ? parsed.toLocal() : parsed;
}

String? _toDateTimeString(Object? value) {
  final parsed = _toNullableDateTime(value);
  return parsed?.toIso8601String();
}

DateTime? _normalizeDateTime(DateTime? value) {
  if (value == null) {
    return null;
  }
  return value.isUtc ? value.toLocal() : value;
}
