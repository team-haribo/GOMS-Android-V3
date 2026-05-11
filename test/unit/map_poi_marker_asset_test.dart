import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/shared/presentation/models/map_poi_marker_asset.dart';

void main() {
  test('exposes current location marker asset', () {
    expect(
      MapPoiMarkerAsset.currentLocation,
      'assets/icons/my_poi.png',
    );
  });

  group('MapPoiMarkerAsset.fromCategory', () {
    test('maps cafe categories to cafe marker', () {
      expect(
        MapPoiMarkerAsset.fromCategory('카페'),
        MapPoiMarkerAsset.cafe,
      );
      expect(
        MapPoiMarkerAsset.fromCategory('Coffee & Dessert'),
        MapPoiMarkerAsset.cafe,
      );
    });

    test('maps pharmacy and hospital categories to medical markers', () {
      expect(
        MapPoiMarkerAsset.fromCategory('약국'),
        MapPoiMarkerAsset.drugstore,
      );
      expect(
        MapPoiMarkerAsset.fromCategory('치과'),
        MapPoiMarkerAsset.hospital,
      );
    });

    test('maps store, culture, and food categories to matching markers', () {
      expect(
        MapPoiMarkerAsset.fromCategory('편의점'),
        MapPoiMarkerAsset.store,
      );
      expect(
        MapPoiMarkerAsset.fromCategory('영화관'),
        MapPoiMarkerAsset.culture,
      );
      expect(
        MapPoiMarkerAsset.fromCategory('한식'),
        MapPoiMarkerAsset.food,
      );
    });

    test('falls back to flag marker for unknown or empty categories', () {
      expect(
        MapPoiMarkerAsset.fromCategory('미분류 장소'),
        MapPoiMarkerAsset.flag,
      );
      expect(
        MapPoiMarkerAsset.fromCategory('   '),
        MapPoiMarkerAsset.flag,
      );
    });
  });
}
