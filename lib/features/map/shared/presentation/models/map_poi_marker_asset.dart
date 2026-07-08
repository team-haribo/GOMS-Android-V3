class MapPoiMarkerAsset {
  MapPoiMarkerAsset._();

  static const String cafe = 'assets/icons/cafe_marker.png';
  static const String culture = 'assets/icons/culture_marker.png';
  static const String currentLocation = 'assets/icons/my_poi.png';
  static const String drugstore = 'assets/icons/drugstore_marker.png';
  static const String flag = 'assets/icons/flag_marker.png';
  static const String food = 'assets/icons/food_marker.png';
  static const String hospital = 'assets/icons/hospital_marker.png';
  static const String store = 'assets/icons/store_marker.png';

  static const int iconWidth = 64;
  static const int iconHeight = 64;
  static const int currentLocationIconWidth = 36;
  static const int currentLocationIconHeight = 36;

  static String fromCategory(String category) {
    final normalized = category.trim().toLowerCase();
    if (normalized.isEmpty) {
      return flag;
    }

    if (_containsAny(normalized, _cafeKeywords)) {
      return cafe;
    }
    if (_containsAny(normalized, _drugstoreKeywords)) {
      return drugstore;
    }
    if (_containsAny(normalized, _hospitalKeywords)) {
      return hospital;
    }
    if (_containsAny(normalized, _storeKeywords)) {
      return store;
    }
    if (_containsAny(normalized, _cultureKeywords)) {
      return culture;
    }
    if (_containsAny(normalized, _foodKeywords)) {
      return food;
    }

    return flag;
  }

  static bool _containsAny(String value, List<String> keywords) {
    for (final keyword in keywords) {
      if (value.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  static const List<String> _cafeKeywords = <String>[
    '카페',
    '커피',
    '디저트',
    '베이커리',
    'cafe',
    'coffee',
    'dessert',
    'bakery',
  ];

  static const List<String> _cultureKeywords = <String>[
    '문화',
    '영화',
    '극장',
    '공연',
    '전시',
    '노래',
    '오락',
    '게임',
    'pc',
    '볼링',
    '당구',
    '만화',
    'culture',
    'movie',
    'cinema',
    'karaoke',
    'arcade',
    'game',
  ];

  static const List<String> _drugstoreKeywords = <String>[
    '약국',
    'pharmacy',
    'drugstore',
  ];

  static const List<String> _hospitalKeywords = <String>[
    '병원',
    '의원',
    '치과',
    '한의원',
    '보건',
    'hospital',
    'clinic',
    'dentist',
    'medical',
  ];

  static const List<String> _storeKeywords = <String>[
    '편의점',
    '마트',
    '상점',
    '쇼핑',
    '문구',
    '서점',
    '꽃집',
    '옷',
    '생활용품',
    'store',
    'mart',
    'shop',
    'market',
    'convenience',
  ];

  static const List<String> _foodKeywords = <String>[
    '식당',
    '음식',
    '한식',
    '중식',
    '일식',
    '양식',
    '분식',
    '치킨',
    '피자',
    '햄버거',
    '국밥',
    '족발',
    '보쌈',
    '고기',
    '술집',
    'restaurant',
    'food',
    'dining',
    'pub',
    'bar',
  ];
}
