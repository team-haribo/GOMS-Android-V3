import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/domain/entities/place_review_entity.dart';
import 'package:goms/features/map/shared/ui/widgets/place_detail_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('상세 화면 리뷰는 내가 쓴 글이 아니면 신고 버튼을 노출한다', (tester) async {
    const place = PopularPlace(
      placeId: 7,
      name: '학생식당',
      category: '한식',
      address: '광주광역시 테스트로 7',
      review: 2,
      recommended: 3,
      coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
    );
    final reviews = [
      PlaceReviewEntity(
        reviewId: 1,
        name: '홍길동',
        grade: 2,
        department: 'SW',
        profileImageUrl: '',
        content: '내가 쓴 후기',
        reviewedAt: DateTime(2026, 4, 21),
      ),
      PlaceReviewEntity(
        reviewId: 2,
        name: '김철수',
        grade: 1,
        department: 'AI',
        profileImageUrl: '',
        content: '다른 사람이 쓴 후기',
        reviewedAt: DateTime(2026, 4, 20),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 359, name: 'SMALL_PHONE'),
            Breakpoint(start: 360, end: 450, name: 'MOBILE'),
            Breakpoint(start: 451, end: 800, name: 'TABLET'),
            Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
          ],
        ),
        home: Scaffold(
          body: PlaceDetailSheet(
            place: place,
            reviews: reviews,
            myReviewIds: const {1},
            isLight: true,
            isReviewLoading: false,
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            snapSizes: const [0.4, 0.8],
            onArrivalPressed: () {},
            onDeparturePressed: () {},
            onWriteReviewPressed: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('내가 쓴 후기'), findsOneWidget);
    expect(find.text('다른 사람이 쓴 후기'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader.toString().contains('assets/icons/report.svg'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/icons/bin.png',
      ),
      findsOneWidget,
    );
  });
}
