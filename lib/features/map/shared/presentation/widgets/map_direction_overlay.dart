import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/map/direction/presentation/models/direction_state.dart';
import 'package:goms/features/map/direction/presentation/viewmodels/map_direction_ui_viewmodel.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';
import 'package:goms/features/map/shared/presentation/widgets/direction_detail_sheet_widget.dart';
import 'package:goms/features/map/shared/presentation/widgets/direction_route_carousel_widget.dart';
import 'package:goms/features/map/shared/presentation/widgets/direction_top_panel_widget.dart';

bool _isDark(ThemeMode mode, BuildContext context) {
  if (mode == ThemeMode.system) {
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }
  return mode == ThemeMode.dark;
}

class MapDirectionOverlay extends ConsumerStatefulWidget {
  final PopularPlace place;
  final DirectionState state;
  final VoidCallback onSwap;
  final ValueChanged<int> onSelect;
  final ValueChanged<String>? onDepartureSelect;

  const MapDirectionOverlay({
    super.key,
    required this.place,
    required this.state,
    required this.onSwap,
    required this.onSelect,
    this.onDepartureSelect,
  });

  @override
  ConsumerState<MapDirectionOverlay> createState() =>
      _MapDirectionOverlayState();
}

class _MapDirectionOverlayState extends ConsumerState<MapDirectionOverlay> {
  final ScrollController _routeScrollController = ScrollController();

  String get _routeSheetKey => '${widget.place.name}|${widget.place.address}';

  @override
  void dispose() {
    _routeScrollController.dispose();
    super.dispose();
  }

  void _handleRouteTap(int index) {
    widget.onSelect(index);
    ref
        .read(routeSheetVisibilityViewModelProvider(_routeSheetKey).notifier)
        .open();
  }

  void _closeRouteSheet() {
    if (!ref.read(routeSheetVisibilityViewModelProvider(_routeSheetKey))) {
      return;
    }
    ref
        .read(routeSheetVisibilityViewModelProvider(_routeSheetKey).notifier)
        .close();
  }

  Color _routeSheetBarrierColor(bool dark) {
    final baseColor = dark ? AppColors.backgroundDark : AppColors.background;
    return baseColor.withValues(alpha: 0.56);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex =
        widget.state.selectedRouteIndex < widget.state.routeOptions.length
            ? widget.state.selectedRouteIndex
            : 0;
    final selectedOption = widget.state.routeOptions.isEmpty
        ? null
        : widget.state.routeOptions[selectedIndex];
    final departureName = widget.state.departure;
    final destinationName = widget.state.destination.isEmpty
        ? widget.place.name
        : widget.state.destination;
    final isRouteSheetVisible = ref.watch(
      routeSheetVisibilityViewModelProvider(_routeSheetKey),
    );

    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    if (isRouteSheetVisible && selectedOption == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _closeRouteSheet();
        }
      });
    }

    return Stack(
      children: [
        if (!isRouteSheetVisible)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              minimum: const EdgeInsets.only(bottom: 8),
              child: _buildRouteCarousel(widget.state, selectedIndex, dark),
            ),
          ),
        if (isRouteSheetVisible && selectedOption != null) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeRouteSheet,
              behavior: HitTestBehavior.opaque,
              child: ColoredBox(
                color: _routeSheetBarrierColor(dark),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: DirectionDetailSheet(
                option: selectedOption,
                departureName: departureName,
                destinationName: destinationName,
                dark: dark,
                onClose: _closeRouteSheet,
              ),
            ),
          ),
        ],
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: DirectionTopPanel(
            departureName: departureName,
            destinationName: destinationName,
            dark: dark,
            onSwap: widget.onSwap,
            onDepartureSelect: widget.onDepartureSelect,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteCarousel(
    DirectionState state,
    int selectedIndex,
    bool dark,
  ) {
    if (state.status == DirectionStatus.loading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 32),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.mainColor),
        ),
      );
    }

    if (state.routeOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return DirectionRouteCarousel(
      scrollController: _routeScrollController,
      routeOptions: state.routeOptions,
      selectedIndex: selectedIndex,
      dark: dark,
      onTap: _handleRouteTap,
    );
  }
}
