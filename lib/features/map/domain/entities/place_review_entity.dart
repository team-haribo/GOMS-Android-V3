class PlaceReviewEntity {
  const PlaceReviewEntity({
    required this.reviewId,
    required this.name,
    required this.grade,
    required this.department,
    required this.profileImageUrl,
    required this.content,
    required this.reviewedAt,
  });

  final int reviewId;
  final String name;
  final int grade;
  final String department;
  final String profileImageUrl;
  final String content;
  final DateTime? reviewedAt;
}
