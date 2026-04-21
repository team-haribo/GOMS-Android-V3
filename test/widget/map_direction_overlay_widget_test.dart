import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/direction/ui/models/direction_state.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/shared/ui/widgets/map_direction_overlay.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('경로 상세 바텀시트가 열려도 지도 가림막은 반투명하다', (tester) async {
    const place = PopularPlace(
      placeId: 7,
      name: '학생식당',
      category: '한식',
      address: '광주광역시 테스트로 7',
      review: 2,
      recommended: 3,
      coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
    );
    const routeOption = RouteOption(
      label: '도보',
      minutes: 8,
      meters: 620,
      taxiFare: 0,
      tollFare: 0,
      steps: [
        RouteStep(
          title: '출발',
          description: '학교에서 출발',
          distanceMeters: 0,
          durationSeconds: 0,
          type: 100,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
        ],
        child: MaterialApp(
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
            body: ColoredBox(
              color: Colors.blue,
              child: MapDirectionOverlay(
                place: place,
                state: const DirectionState(
                  status: DirectionStatus.success,
                  departure: '학교',
                  destination: '학생식당',
                  routeOptions: [routeOption],
                ),
                onSwap: () {},
                onSelect: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('도보'));
    await tester.pumpAndSettle();

    final barrier = tester.widget<Container>(
      find
          .byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.color != null &&
                (widget.color!.a * 255.0).round().clamp(0, 255) < 255,
          )
          .first,
    );

    expect(barrier.color, isNotNull);
    expect(
      (barrier.color!.a * 255.0).round().clamp(0, 255),
      lessThan(255),
    );
  });
}

class _FakeThemeModeNotifier extends ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async => ThemeMode.light;
}
