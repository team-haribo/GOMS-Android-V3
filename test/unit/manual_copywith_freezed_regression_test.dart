import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/member/ui/models/student_council_student_model.dart';

void main() {
  group('manual copyWith to freezed regression', () {
    test('PopularPlace copyWith preserves existing values by default', () {
      const original = PopularPlace(
        placeId: 1,
        name: '테스트 카페',
        category: '카페',
        address: '광주',
        review: 2,
        recommended: 3,
        isRecommended: false,
        distanceMeters: 120,
        coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
      );

      final updated = original.copyWith(name: '수정된 카페');

      expect(updated.name, '수정된 카페');
      expect(updated.category, original.category);
      expect(updated.distanceMeters, original.distanceMeters);
      expect(updated.coordinate, original.coordinate);
    });

    test('RecommendedPlaceEntity copyWith preserves nullable fields', () {
      const original = RecommendedPlaceEntity(
        placeId: 1,
        reviewCount: 2,
        recommendCount: 3,
        recommended: true,
        placeName: '장소',
        category: '카페',
        address: '광주',
        coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
      );

      final updated = original.copyWith(recommendCount: 9);

      expect(updated.recommendCount, 9);
      expect(updated.placeName, original.placeName);
      expect(updated.coordinate, original.coordinate);
    });

    test('PopularPlace.fromRecommendedPlace trims values and applies defaults',
        () {
      const place = RecommendedPlaceEntity(
        placeId: 7,
        reviewCount: 11,
        recommendCount: 13,
        recommended: true,
        placeName: '  학생식당  ',
        category: '  한식  ',
        address: '  광주 광산구  ',
        coordinate: MapCoordinate(latitude: 35.2, longitude: 126.8),
      );

      final popularPlace = PopularPlace.fromRecommendedPlace(place);

      expect(popularPlace.placeId, 7);
      expect(popularPlace.name, '학생식당');
      expect(popularPlace.category, '한식');
      expect(popularPlace.address, '광주 광산구');
      expect(popularPlace.review, 11);
      expect(popularPlace.recommended, 13);
      expect(popularPlace.isRecommended, isTrue);
      expect(
        popularPlace.coordinate,
        const MapCoordinate(latitude: 35.2, longitude: 126.8),
      );
    });

    test('PopularPlace.fromRecommendedPlace supports fallback overrides', () {
      const place = RecommendedPlaceEntity(
        placeId: 9,
        reviewCount: 1,
        recommendCount: 2,
        recommended: false,
        placeName: '   ',
        category: null,
        address: '   ',
        coordinate: null,
      );

      final popularPlace = PopularPlace.fromRecommendedPlace(
        place,
        fallbackAddress: gomsSchoolAddress,
      );

      expect(popularPlace.name, '추천 장소 9');
      expect(popularPlace.category, '장소');
      expect(popularPlace.address, gomsSchoolAddress);
      expect(popularPlace.coordinate, gomsFallbackSchoolCoordinate);
    });

    test('StudentCouncilStudentModel copyWith updates selected role only', () {
      const original = StudentCouncilStudentModel(
        memberId: 1,
        name: '학생',
        grade: 2,
        department: 'SW',
        studentRole: StudentRole.student,
      );

      final updated = original.copyWith(studentRole: StudentRole.council);

      expect(updated.studentRole, StudentRole.council);
      expect(updated.name, original.name);
      expect(updated.profileImageUrl, original.profileImageUrl);
    });
  });
}
