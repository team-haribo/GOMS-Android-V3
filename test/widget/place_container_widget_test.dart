import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/shared/ui/widgets/place_container.dart';

void main() {
  testWidgets('후기 플레이스 컨테이너 삭제 아이콘은 컨테이너 중앙에 정렬된다', (tester) async {
    const containerKey = Key('review-place-container');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PlaceContainer.review(
              key: containerKey,
              placeName: '학생식당',
              category: '한식',
              address: '광주광역시 테스트로 10',
              reviewContent: '맛있고 양이 많아요',
              reviewCreatedAt: DateTime(2026, 4, 23),
              onActionPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final containerCenterY = tester.getCenter(find.byKey(containerKey)).dy;
    final iconCenterY = tester.getCenter(_findSvgAsset('assets/icons/bin.svg')).dy;

    expect(iconCenterY, containerCenterY);
  });

  testWidgets('인기 플레이스 컨테이너 하트 아이콘은 컨테이너 중앙에 정렬된다', (tester) async {
    const containerKey = Key('popular-place-container');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PlaceContainer.popular(
              key: containerKey,
              placeName: '학생식당',
              category: '한식',
              address: '광주광역시 테스트로 10',
              review: 2,
              recommended: 3,
              isLiked: false,
              onLikePressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final containerCenterY = tester.getCenter(find.byKey(containerKey)).dy;
    final iconCenterY = tester.getCenter(_findSvgAsset('assets/icons/heart.svg')).dy;

    expect(iconCenterY, containerCenterY);
  });
}

Finder _findSvgAsset(String assetPath) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is SvgPicture && widget.bytesLoader.toString().contains(assetPath),
  );
}
