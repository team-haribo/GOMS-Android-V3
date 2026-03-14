class MapPageReviewModel {
  final String placeName;
  final String category;
  final String address;
  final String reviewDetailContent;
  final DateTime createdAt;

  const MapPageReviewModel({
    required this.placeName,
    required this.category,
    required this.address,
    required this.reviewDetailContent,
    required this.createdAt,
  });
}
