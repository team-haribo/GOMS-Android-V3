import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/shared/ui/models/map_screen_type.dart';
import 'package:goms/features/map/shared/ui/screens/map_base_screen.dart';

void main() {
  const searchedPlace = PopularPlace(
    placeId: 1,
    name: '검색 장소',
    category: '카페',
    address: '광주광역시 테스트로 1',
    review: 4,
    recommended: 8,
    coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
  );
  const markerPlace = PopularPlace(
    placeId: 2,
    name: '마커 장소',
    category: '한식',
    address: '광주광역시 테스트로 2',
    review: 1,
    recommended: 3,
    coordinate: MapCoordinate(latitude: 35.2, longitude: 126.8),
  );
  const popularPlace = PopularPlace(
    placeId: 3,
    name: '인기 장소',
    category: '편의점',
    address: '광주광역시 테스트로 3',
    review: 2,
    recommended: 5,
    coordinate: MapCoordinate(latitude: 35.3, longitude: 126.7),
  );

  group('resolveCandidatePlaces', () {
    test('메인 화면에서는 검색 결과를 우선 사용한다', () {
      final places = resolveCandidatePlaces(
        type: MapScreenType.main,
        routePlace: null,
        searchedPlaces: const [searchedPlace],
        markerPlaces: const [markerPlace],
        popularPlaces: const [popularPlace],
      );

      expect(places, const [searchedPlace]);
    });

    test('상세 화면에서는 전달된 장소만 사용한다', () {
      final places = resolveCandidatePlaces(
        type: MapScreenType.detail,
        routePlace: popularPlace,
        searchedPlaces: const [searchedPlace],
        markerPlaces: const [markerPlace],
        popularPlaces: const [popularPlace],
      );

      expect(places, const [popularPlace]);
    });
  });

  group('resolveVisiblePlaces', () {
    test('메인 화면 첫 진입 시에는 라벨을 노출하지 않는다', () {
      final places = resolveVisiblePlaces(
        type: MapScreenType.main,
        routePlace: null,
        selectedPlace: null,
        popularPlaces: const [popularPlace],
      );

      expect(places, isEmpty);
    });

    test('메인 화면에서 장소를 선택하면 해당 장소 라벨만 노출한다', () {
      final places = resolveVisiblePlaces(
        type: MapScreenType.main,
        routePlace: null,
        selectedPlace: searchedPlace,
        popularPlaces: const [popularPlace],
      );

      expect(places, const [searchedPlace]);
    });

    test('상세 화면에서는 전달된 장소를 계속 노출한다', () {
      final places = resolveVisiblePlaces(
        type: MapScreenType.detail,
        routePlace: popularPlace,
        selectedPlace: searchedPlace,
        popularPlaces: const [markerPlace],
      );

      expect(places, const [popularPlace]);
    });
  });

  group('findNearestPlaceWithinRadius', () {
    test('반경 안에서 가장 가까운 장소를 반환한다', () {
      final place = findNearestPlaceWithinRadius(
        tapCoordinate: const MapCoordinate(latitude: 35.10001, longitude: 126.90001),
        places: const [searchedPlace, markerPlace],
        maxDistanceMeters: 80,
      );

      expect(place, searchedPlace);
    });

    test('반경 밖이면 null을 반환한다', () {
      final place = findNearestPlaceWithinRadius(
        tapCoordinate: const MapCoordinate(latitude: 35.5, longitude: 127.5),
        places: const [searchedPlace, markerPlace, popularPlace],
        maxDistanceMeters: 80,
      );

      expect(place, isNull);
    });
  });

}
