import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/shared/presentation/widgets/review_list_container.dart';

void main() {
  testWidgets('후기 리스트 신고 아이콘은 컨테이너 중앙에 정렬된다', (tester) async {
    const containerKey = Key('review-list-report-container');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewListContainer(
            key: containerKey,
            reviewId: 1,
            name: '김민솔',
            grade: 9,
            major: 'SW',
            reviewDetailContent: '좋아요',
            createdAt: DateTime(2026, 4, 23),
            isMine: false,
            onReport: (_, __) async {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      tester.getCenter(_findSvgAsset('assets/icons/report.svg')).dy,
      closeTo(tester.getCenter(find.byKey(containerKey)).dy, 0.5),
    );
  });

  testWidgets('후기 리스트 삭제 아이콘은 컨테이너 중앙에 정렬된다', (tester) async {
    const containerKey = Key('review-list-delete-container');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewListContainer(
            key: containerKey,
            reviewId: 1,
            name: '김민솔',
            grade: 9,
            major: 'SW',
            reviewDetailContent: '좋아요',
            createdAt: DateTime(2026, 4, 23),
            isMine: true,
            onDelete: (_) async {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      tester.getCenter(_findSvgAsset('assets/icons/bin.svg')).dy,
      closeTo(tester.getCenter(find.byKey(containerKey)).dy, 0.5),
    );
  });
}

Finder _findSvgAsset(String assetPath) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is SvgPicture && widget.bytesLoader.toString().contains(assetPath),
  );
}
