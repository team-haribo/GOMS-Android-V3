import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/widgets/goms_bottom_navigation.dart';
import 'package:goms/features/map/discovery/presentation/providers/map_screen_provider.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: GomsBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == 0) {
            ref.read(mapReentryRefreshSignalProvider.notifier).state++;
          }
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
