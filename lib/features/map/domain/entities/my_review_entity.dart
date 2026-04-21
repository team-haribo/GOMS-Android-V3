class MyReviewEntity {
  const MyReviewEntity({
    required this.reviewId,
    required this.placeId,
    required this.placeName,
    required this.categoryName,
    required this.address,
    required this.content,
    required this.reviewedAt,
  });

  final int reviewId;
  final int placeId;
  final String placeName;
  final String categoryName;
  final String address;
  final String content;
  final DateTime? reviewedAt;
}
