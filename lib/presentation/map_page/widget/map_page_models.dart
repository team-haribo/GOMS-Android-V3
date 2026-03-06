class PopularPlace{
  final String name;
  final String category;
  final String address;
  final int review;
  final int recommended;
  PopularPlace({
    required this.name,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
});

  factory PopularPlace.fromMap(Map<String,dynamic> map) {
    return PopularPlace(
      name: map['name'],
      category: map['category'],
      address: map['address'] ,
      review: map['review'],
      recommended: map['recommended'],
    );


  }
}