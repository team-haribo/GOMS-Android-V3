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
  testWidgets(
      'MapDirectionOverlay hides route cards and opens draggable detail sheet on tap',
      (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var selectedIndex = 0;

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
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: MapDirectionOverlay(
                place: const PopularPlace(
                  placeId: 1,
                  name: '학생식당',
                  category: '한식',
                  address: '광주광역시 테스트로 1',
                  review: 2,
                  recommended: 3,
                  coordinate: MapCoordinate(latitude: 35.1, longitude: 126.9),
                ),
                state: DirectionState(
                  status: DirectionStatus.success,
                  departure: '학교',
                  destination: '학생식당',
                  selectedRouteIndex: selectedIndex,
                  routeOptions: const [
                    RouteOption(
                      label: '추천',
                      minutes: 10,
                      meters: 500,
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
                    ),
                    RouteOption(
                      label: '빠른 길',
                      minutes: 8,
                      meters: 450,
                      taxiFare: 0,
                      tollFare: 0,
                      steps: [
                        RouteStep(
                          title: '우회전',
                          description: '빠른 길로 이동',
                          distanceMeters: 100,
                          durationSeconds: 60,
                          type: 0,
                        ),
                      ],
                    ),
                  ],
                ),
                onSwap: () {},
                onSelect: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('추천'), findsOneWidget);
    expect(find.text('빠른 길'), findsOneWidget);
    expect(find.byType(DraggableScrollableSheet), findsNothing);

    await tester.tap(find.text('빠른 길'));
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(find.text('추천'), findsNothing);
    expect(find.text('빠른 길'), findsNothing);
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    expect(sheet.minChildSize, greaterThanOrEqualTo(0.055));
    expect(sheet.minChildSize, lessThanOrEqualTo(0.06));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SliverPersistentHeader && widget.pinned,
      ),
      findsOneWidget,
    );
    expect(find.text('빠른 길 경로'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsNothing);
    expect(find.text('추천'), findsOneWidget);
    expect(find.text('빠른 길'), findsOneWidget);
  });
}

class _FakeThemeModeNotifier extends ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async => ThemeMode.light;
}
