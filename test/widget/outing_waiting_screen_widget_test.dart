import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';
import 'package:goms/features/late/presentation/viewmodels/late_rank_students_provider.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/presentation/screens/outing_waiting_screen.dart';
import 'package:goms/features/outing/presentation/viewmodels/current_outing_students_provider.dart';
import 'package:goms/features/outing/presentation/viewmodels/my_outing_status_provider.dart';
import 'package:goms/features/profile/settings/presentation/viewmodels/settings_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('OutingWaitingScreen renders outing list, count, and late top3',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) => RoleEnum.user),
          themeModeProvider.overrideWith(_FakeThemeModeNotifier.new),
          settingsProvider.overrideWith(_FakeSettingsNotifier.new),
          myOutingStatusProvider.overrideWith(_FakeMyOutingStatusNotifier.new),
          currentOutingStudentsProvider.overrideWith(
            _FakeCurrentOutingStudentsNotifier.new,
          ),
          lateRankStudentsProvider.overrideWith(
            _FakeLateRankStudentsNotifier.new,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
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
          home: const OutingWaitingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('한지호'), findsOneWidget);
    expect(find.text('김하린'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('명이 외출중'), findsOneWidget);
    expect(find.text('민준'), findsOneWidget);
    expect(find.text('서윤'), findsOneWidget);
    expect(find.text('도윤'), findsOneWidget);
    expect(find.text('하은'), findsNothing);
  });
}

class _FakeThemeModeNotifier extends ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async => ThemeMode.system;
}

class _FakeSettingsNotifier extends SettingsNotifier {
  @override
  Future<SettingsState> build() async => const SettingsState(
        showClock: false,
        outingPushAlarm: true,
        cameraLaunch: false,
      );
}

class _FakeMyOutingStatusNotifier extends MyOutingStatusNotifier {
  @override
  Future<MyOutingStatusEntity> build() async => const MyOutingStatusEntity(
        memberId: 1,
        status: OutingStatusType.coming,
        name: '이주언',
        grade: 8,
        department: 'AI',
      );
}

class _FakeCurrentOutingStudentsNotifier extends CurrentOutingStudentsNotifier {
  @override
  Future<List<OutingStudentEntity>> build() async => [
        OutingStudentEntity(
          memberId: 1,
          name: '한지호',
          grade: 8,
          department: 'AI',
          outingAt: DateTime(2026, 4, 2, 10, 30),
        ),
        OutingStudentEntity(
          memberId: 2,
          name: '김하린',
          grade: 9,
          department: 'SW',
          outingAt: DateTime(2026, 4, 2, 11, 0),
        ),
      ];
}

class _FakeLateRankStudentsNotifier extends LateRankStudentsNotifier {
  @override
  Future<List<LateRankStudentEntity>> build() async => [
        LateRankStudentEntity(
          memberId: 1,
          name: '민준',
          grade: 8,
          department: 'AI',
          comingAt: DateTime(2026, 4, 2, 8, 30),
        ),
        LateRankStudentEntity(
          memberId: 2,
          name: '서윤',
          grade: 9,
          department: 'SW',
          comingAt: DateTime(2026, 4, 2, 8, 32),
        ),
        LateRankStudentEntity(
          memberId: 3,
          name: '도윤',
          grade: 7,
          department: 'DESIGN',
          comingAt: DateTime(2026, 4, 2, 8, 35),
        ),
        LateRankStudentEntity(
          memberId: 4,
          name: '하은',
          grade: 6,
          department: 'IOT',
          comingAt: DateTime(2026, 4, 2, 8, 40),
        ),
      ];
}
