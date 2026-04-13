import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/recommended_place_entity.dart';
import 'package:goms/features/map/shared/presentation/providers/map_screen_provider.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';

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

    test('StudentCouncilStudentEntity copyWith updates selected role only', () {
      const original = StudentCouncilStudentEntity(
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

    test('MapScreenUiState copyWith preserves untouched flags', () {
      const original = MapScreenUiState(
        isSdkReady: true,
        isFetchingRoute: false,
      );

      final updated = original.copyWith(isFetchingRoute: true);

      expect(updated.isSdkReady, isTrue);
      expect(updated.isFetchingRoute, isTrue);
    });
  });
}
