class MapPageReviewModels {
  final String placeName;
  final String category;
  final String address;
  final String reviewDetailContent;
  final DateTime createdAt;

  MapPageReviewModels({
    required this.placeName,
    required this.category,
    required this.address,
    required this.reviewDetailContent,
    required this.createdAt,
  });


  factory MapPageReviewModels.fromMap(Map<String, dynamic> map) {
    return MapPageReviewModels(placeName: map['placeName'],
        category: map['category'],
        address: map['address'],
        reviewDetailContent: map['reviewDetailContent'],
        createdAt: map['createdAt'],);
  }
}