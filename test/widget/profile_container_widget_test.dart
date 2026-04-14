import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/home/shared/presentation/widgets/profile_container.dart';
import 'package:goms/features/home/shared/presentation/widgets/time_display.dart';
import 'package:goms/features/outing/domain/enums/outing_status.dart';
import 'package:goms/features/profile/presentation/providers/settings_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('showClock이 false면 프로필 이미지가 보이고 시계는 숨겨진다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(_ShowClockFalseNotifier.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
              Breakpoint(
                start: 1921,
                end: double.infinity,
                name: AppBreakpoints.largeDesktop,
              ),
            ],
          ),
          home: const Scaffold(
            body: ProfileContainer(
              name: '이주언',
              grade: 8,
              major: 'AI',
              lateCount: 3,
              status: OutingStatus.waiting,
              profileImageUrl: '',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TimeDisplay), findsNothing);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('이주언'), findsOneWidget);
    expect(find.text('8기 | AI과'), findsOneWidget);
  });



  testWidgets('어드민 컨테이너에서는 기수 정보가 이름 아래에 표시된다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(_ShowClockFalseNotifier.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
              Breakpoint(
                start: 1921,
                end: double.infinity,
                name: AppBreakpoints.largeDesktop,
              ),
            ],
          ),
          home: const Scaffold(
            body: ProfileContainer(
              name: '이주언',
              grade: 8,
              major: 'AI',
              lateCount: 0,
              status: OutingStatus.admin,
              profileImageUrl: '',
              showLateCount: false,
              showInfoBelowName: true,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final nameFinder = find.text('이주언');
    final infoFinder = find.text('8기 | AI과');

    expect(nameFinder, findsOneWidget);
    expect(infoFinder, findsOneWidget);
    expect(
      tester.getTopLeft(infoFinder).dy,
      greaterThan(tester.getTopLeft(nameFinder).dy),
    );
  });

  testWidgets('showClock이 true면 시계가 보이고 프로필 이미지는 숨겨진다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(_ShowClockTrueNotifier.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
              Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
              Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
              Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
              Breakpoint(
                start: 1921,
                end: double.infinity,
                name: AppBreakpoints.largeDesktop,
              ),
            ],
          ),
          home: const Scaffold(
            body: ProfileContainer(
              name: '이주언',
              grade: 8,
              major: 'AI',
              lateCount: 3,
              status: OutingStatus.waiting,
              profileImageUrl: '',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TimeDisplay), findsOneWidget);
    expect(find.byType(CircleAvatar), findsNothing);
    expect(find.text('이주언'), findsOneWidget);
    expect(find.text('8기 | AI과'), findsOneWidget);
  });
}

class _ShowClockFalseNotifier extends SettingsNotifier {
  @override
  Future<SettingsState> build() async => const SettingsState(
        showClock: false,
        outingPushAlarm: true,
        cameraLaunch: false,
      );
}

class _ShowClockTrueNotifier extends SettingsNotifier {
  @override
  Future<SettingsState> build() async => const SettingsState(
        showClock: true,
        outingPushAlarm: true,
        cameraLaunch: false,
      );
}
