import 'package:project_setting/presentation/map_page/widget/map_page_models.dart';
import 'package:project_setting/presentation/map_page/widget/map_page_review_models.dart';

final List<PopularPlace> popularPlaces = [
  PopularPlace(
    name: '메가MGC커피 광주송정시장점',
    category: '카페',
    address: '광주 광산구 내상로 23 가동 1층',
    review: 10,
    recommended: 20,
  ),
];



final List<MapPageReviewModels> reviewModels = [
  MapPageReviewModels(
    placeName: '봉명동 커피',
    category: '카페',
    address: '광주소프트웨어마이스터고',
    reviewDetailContent: '굳굳굳굳',
    createdAt: DateTime.now(),
  ),
];