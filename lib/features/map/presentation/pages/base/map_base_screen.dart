import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/features/map/presentation/pages/base/models/map_screen_type.dart';
import 'package:goms/features/map/presentation/pages/base/widgets/map_detail_overlay.dart';
import 'package:goms/features/map/presentation/pages/base/widgets/map_direction_overlay.dart';
import 'package:goms/features/map/presentation/pages/base/widgets/map_main_overlay.dart';
import 'package:goms/features/map/presentation/pages/base/widgets/map_scaffold.dart';
import 'package:goms/features/map/presentation/pages/direction/models/direction_state.dart';
import 'package:goms/features/map/presentation/pages/direction/viewModels/direction_provider.dart';
import 'package:goms/features/map/presentation/pages/main/models/map_page_state.dart';
import 'package:goms/features/map/presentation/pages/main/models/popular_place.dart';
import 'package:goms/features/map/presentation/pages/main/viewModels/map_page_provider.dart';
import 'package:goms/features/map/presentation/widgets/kakao_map_background.dart';

class MapBaseScreen extends ConsumerStatefulWidget {
  final MapScreenType type;
  final PopularPlace? place;

  const MapBaseScreen({
    super.key,
    required this.type,
    this.place,
  });

  @override
  ConsumerState<MapBaseScreen> createState() => _MapBaseScreenState();
}

class _MapBaseScreenState extends ConsumerState<MapBaseScreen> {
  @override
  void initState() {
    super.initState();
    _syncDirectionDestination();
  }

  @override
  void didUpdateWidget(covariant MapBaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.place?.name != widget.place?.name ||
        oldWidget.type != widget.type) {
      _syncDirectionDestination();
    }
  }

  void _syncDirectionDestination() {
    if (widget.type != MapScreenType.direction || widget.place == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.place == null) return;
      ref.read(directionProvider.notifier).setDestination(widget.place!.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    if (widget.type != MapScreenType.main && place == null) {
      return const MapScaffold(
        body: const Center(child: Text('선택된 장소가 없습니다.')),
      );
    }

    if (widget.type == MapScreenType.main ||
        widget.type == MapScreenType.detail) {
      ref.listen<MapPageState>(mapPageProvider, (previous, next) {
        if (!mounted) return;
        if (next.status == MapPageStatus.failure && next.errorMessage != null) {
          ref.read(mapPageProvider.notifier).clearError();
          _showError(next.errorMessage!);
        }
      });
    }

    if (widget.type == MapScreenType.direction) {
      ref.listen<DirectionState>(directionProvider, (previous, next) {
        if (!mounted) return;
        if (next.status == DirectionStatus.failure &&
            next.errorMessage != null) {
          ref.read(directionProvider.notifier).clearError();
          _showError(next.errorMessage!);
        }
      });
    }

    return MapScaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: KakaoMapBackground(
              focusPlace: place,
              showRoutePreview: widget.type == MapScreenType.direction,
            ),
          ),
          Positioned.fill(child: _buildOverlay(place)),
        ],
      ),
    );
  }

  Widget _buildOverlay(PopularPlace? place) {
    final overlay = switch (widget.type) {
      MapScreenType.main => MapMainOverlay(state: ref.watch(mapPageProvider)),
      MapScreenType.detail => MapDetailOverlay(
          place: place!,
          state: ref.watch(mapPageProvider),
        ),
      MapScreenType.direction => MapDirectionOverlay(
          place: place!,
          state: ref.watch(directionProvider),
          onSwap: () => ref.read(directionProvider.notifier).swapLocations(),
          onSelect: (index) =>
              ref.read(directionProvider.notifier).selectRoute(index),
        ),
    };

    if (widget.type == MapScreenType.direction) {
      return overlay;
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s16),
        child: overlay,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.negative,
      ),
    );
  }
}



