import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/map/direction/ui/providers/map_direction_ui_provider.dart';
import 'package:goms/features/map/direction/ui/models/direction_state.dart';
import 'package:goms/features/map/discovery/ui/models/popular_place.dart';
import 'package:goms/features/map/shared/ui/widgets/direction_detail_sheet_widget.dart';
import 'package:goms/features/map/shared/ui/widgets/direction_route_carousel_widget.dart';
import 'package:goms/features/map/shared/ui/widgets/direction_top_panel_widget.dart';

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
    ref.read(routeSheetVisibilityProvider(_routeSheetKey).notifier).state =
        true;
  }

  void _closeRouteSheet() {
    if (!ref.read(routeSheetVisibilityProvider(_routeSheetKey))) {
      return;
    }
    ref.read(routeSheetVisibilityProvider(_routeSheetKey).notifier).state =
        false;
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
      routeSheetVisibilityProvider(_routeSheetKey),
    );

    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    return Stack(
      children: [
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
        if (isRouteSheetVisible && selectedOption != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeRouteSheet,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: _routeSheetBarrierColor(dark),
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            minimum: const EdgeInsets.only(bottom: 8),
            child: _buildStateContent(
              state: widget.state,
              routeCarousel: DirectionRouteCarousel(
                scrollController: _routeScrollController,
                routeOptions: widget.state.routeOptions,
                selectedIndex: selectedIndex,
                dark: dark,
                onTap: _handleRouteTap,
              ),
              routeSheet: selectedOption == null
                  ? const SizedBox.shrink()
                  : DirectionDetailSheet(
                      option: selectedOption,
                      departureName: departureName,
                      destinationName: destinationName,
                      dark: dark,
                      onClose: _closeRouteSheet,
                    ),
              isRouteSheetVisible: isRouteSheetVisible,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateContent({
    required DirectionState state,
    required Widget routeCarousel,
    required Widget routeSheet,
    required bool isRouteSheetVisible,
  }) {
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

    return isRouteSheetVisible ? routeSheet : routeCarousel;
  }
}
