import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/late/data/response/late_rank_student_response.dart';
import 'package:goms/features/late/data/response/list/late_rank_students_response.dart';
import 'package:goms/features/map/data/response/place_review_list_response.dart';
import 'package:goms/features/map/data/response/place_review_response.dart';
import 'package:goms/features/map/data/response/recommended_place_response.dart';
import 'package:goms/features/map/data/response/recommended_places_response.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/member/data/response/member_dto.dart';
import 'package:goms/features/member/data/response/student_council_students_response.dart';
import 'package:goms/features/outing/data/response/qr/process_coming_by_qr_response.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/report/data/response/report_detail_response.dart';
import 'package:goms/features/report/data/response/report_list_response.dart';
import 'package:goms/features/report/data/response/report_resolve_response.dart';
import 'package:goms/features/report/data/response/report_response.dart';

void main() {
  group('manual json parsing regression', () {
    test('LateRankStudentResponse supports fallback aliases and defaults', () {
      final response = LateRankStudentResponse.fromJson({
        'memberId': 1,
        'name': '홍길동',
        'grade': 2,
        'department': 'SW',
        'profileUrl': 'https://example.com/profile.png',
        'comingAt': '2026-04-13T09:00:00Z',
      });

      expect(response.memberId, 1);
      expect(response.profileImageUrl, 'https://example.com/profile.png');
      expect(response.comingAt, DateTime.parse('2026-04-13T09:00:00Z'));
    });

    test('LateRankStudentsResponse filters non-map list items', () {
      final response = LateRankStudentsResponse.fromJson({
        'students': [
          {
            'memberId': 1,
            'name': '홍길동',
            'grade': 1,
            'department': 'SW',
            'profileImageUrl': '',
            'comingAt': '2026-04-13T09:00:00Z',
          },
          'ignored',
        ],
      });

      expect(response.students, hasLength(1));
      expect(response.students.single.memberId, 1);
    });

    test('RecommendedPlaceResponse resolves category and address aliases', () {
      final response = RecommendedPlaceResponse.fromJson({
        'placeId': 7,
        'reviewCount': 3,
        'recommendCount': 5,
        'recommended': true,
        'placeName': '테스트 카페',
        'categoryGroupName': '카페',
        'roadAddress': '광주 북구 테스트로 1',
        'latitude': 35.1,
        'longitude': 126.9,
      });

      expect(response.category, '카페');
      expect(response.address, '광주 북구 테스트로 1');
      expect(response.toEntity().coordinate?.latitude, 35.1);
    });

    test('RecommendedPlacesResponse filters non-map list items', () {
      final response = RecommendedPlacesResponse.fromJson({
        'places': [
          {
            'placeId': 1,
            'reviewCount': 0,
            'recommendCount': 0,
            'recommended': false,
          },
          123,
        ],
      });

      expect(response.places, hasLength(1));
      expect(response.places.single.placeId, 1);
    });

    test('PlaceReviewResponse parses snake_case payload', () {
      final response = PlaceReviewResponse.fromJson({
        'review_id': 11,
        'name': '홍길동',
        'grade': 2,
        'department': 'SW',
        'profileImageUrl': 'https://example.com/p.png',
        'content': '좋아요',
        'reviewed_at': '2026-04-13T10:00:00Z',
      });

      expect(response.reviewId, 11);
      expect(response.reviewedAt, DateTime.parse('2026-04-13T10:00:00Z'));
    });

    test('PlaceReviewListResponse filters non-map list items', () {
      final response = PlaceReviewListResponse.fromJson({
        'reviews': [
          {
            'review_id': 1,
            'name': '리뷰어',
            'grade': 1,
            'department': 'SW',
            'profileImageUrl': '',
            'content': '리뷰',
          },
          null,
        ],
      });

      expect(response.reviews, hasLength(1));
      expect(response.reviews.single.reviewId, 1);
    });

    test('MemberDto keeps defaults for missing values', () {
      final response = MemberDto.fromJson(const {});

      expect(response.id, 0);
      expect(response.name, '');
      expect(response.studentNumber, '');
      expect(response.role, '');
      expect(response.profileImageUrl, '');
    });

    test('StudentCouncilStudentResponse supports alias keys and role mapping',
        () {
      final response = StudentCouncilStudentResponse.fromJson({
        'id': '3',
        'name': '학생',
        'grade': '2',
        'department': 'AI',
        'profileUrl': 'https://example.com/profile.png',
        'studentRole': 'ROLE_STUDENT_COUNCIL',
        'outingStatus': 'ALLOWED',
      });

      expect(response.memberId, 3);
      expect(response.profileImageUrl, 'https://example.com/profile.png');
      expect(response.role, 'ROLE_STUDENT_COUNCIL');
      expect(response.status, 'ALLOWED');
      expect(response.studentRole.name, 'council');
    });

    test('StudentCouncilStudentsResponse filters non-map list items', () {
      final response = StudentCouncilStudentsResponse.fromJson({
        'students': [
          {
            'memberId': 1,
            'name': '학생',
            'grade': 1,
            'department': 'SW',
            'profileImageUrl': '',
            'role': 'ROLE_STUDENT',
            'status': 'ALLOWED',
          },
          false,
        ],
      });

      expect(response.students, hasLength(1));
      expect(response.students.single.memberId, 1);
    });

    test('ProcessComingByQrResponse accepts null lateId', () {
      final response = ProcessComingByQrResponse.fromJson({
        'action': 'IN',
        'outingId': 31,
        'status': 'COMING',
        'comingAt': '2026-04-13T16:35:38.1202809',
        'lateCreated': false,
        'lateId': null,
      });

      expect(response.action, OutingAction.inAction);
      expect(response.status, OutingStatusType.coming);
      expect(response.lateCreated, isFalse);
      expect(response.lateId, isNull);
    });

    test('Report responses preserve parser behavior and aliases', () {
      final summary = ReportResponse.fromJson({
        'reportId': '10',
        'reviewId': 12,
        'reviewerMemberId': '15',
        'reviewerName': '신고자',
        'reviewerGrade': '3',
        'reviewerDepartment': 'IOT',
        'profileUrl': 'https://example.com/profile.png',
        'reportCreatedAt': '2026-04-13T12:00:00Z',
        'reportStatus': 'APPROVED',
        'deletedBy': '',
      });

      expect(summary.reportId, 10);
      expect(
        summary.reviewerProfileImageUrl,
        'https://example.com/profile.png',
      );
      expect(summary.reportStatus, ReportStatus.approved);
      expect(summary.deletedBy, isNull);

      final detail = ReportDetailResponse.fromJson({
        'reportId': 10,
        'reviewId': 12,
        'reviewCreatedAt': '2026-04-12T12:00:00Z',
        'reviewerMemberId': 15,
        'reviewerName': '신고자',
        'reviewerGrade': 3,
        'reviewerDepartment': 'IOT',
        'reviewerProfileUrl': 'https://example.com/profile.png',
        'reviewContent': '리뷰 내용',
        'reportContent': '신고 내용',
        'reportCreatedAt': '2026-04-13T12:00:00Z',
        'reportStatus': 'REJECTED',
      });

      expect(detail.reviewCreatedAt, DateTime.parse('2026-04-12T12:00:00Z'));
      expect(detail.reportStatus, ReportStatus.rejected);

      final resolve = ReportResolveResponse.fromJson({
        'report_id': '5',
        'review_id': 9,
        'report_status': 'PENDING',
        'resolved_at': '2026-04-13T13:00:00Z',
        'resolved_by': '2',
      });

      expect(resolve.reportId, 5);
      expect(resolve.resolvedBy, 2);
      expect(resolve.reportStatus, ReportStatus.pending);
    });

    test('ReportListResponse filters non-map list items', () {
      final response = ReportListResponse.fromJson({
        'reports': [
          {
            'reportId': 1,
            'reviewId': 2,
            'reviewerMemberId': 3,
            'reviewerName': '신고자',
            'reviewerGrade': 1,
            'reviewerDepartment': 'SW',
            'reportStatus': 'PENDING',
          },
          'ignored',
        ],
      });

      expect(response.reports, hasLength(1));
      expect(response.reports.single.reportId, 1);
    });
  });
}
