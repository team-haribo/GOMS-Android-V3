import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/presentation/pages/direction/viewModels/map_direction_ui_provider.dart';
import 'package:goms/features/map/presentation/pages/direction/models/direction_state.dart';
import 'package:goms/features/map/presentation/pages/main/models/popular_place.dart';

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
    ref.read(routeSheetVisibilityProvider(_routeSheetKey).notifier).state = true;
  }

  void _closeRouteSheet() {
    if (!ref.read(routeSheetVisibilityProvider(_routeSheetKey))) {
      return;
    }
    ref.read(routeSheetVisibilityProvider(_routeSheetKey).notifier).state =
        false;
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

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _DirectionTopPanel(
            departureName: departureName,
            destinationName: destinationName,
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
                color: (_isDark(themeMode, context)
                    ? AppColors.backgroundDark
                    : AppColors.background),
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildStateContent(
            state: widget.state,
            routeCarousel: _DirectionRouteCarousel(
              scrollController: _routeScrollController,
              routeOptions: widget.state.routeOptions,
              selectedIndex: selectedIndex,
              onTap: _handleRouteTap,
            ),
            routeSheet: selectedOption == null
                ? const SizedBox.shrink()
                : _DirectionDetailSheet(
                    option: selectedOption,
                    departureName: departureName,
                    destinationName: destinationName,
                    onClose: _closeRouteSheet,
                  ),
            isRouteSheetVisible: isRouteSheetVisible,
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

class _DirectionTopPanel extends ConsumerWidget {
  final String departureName;
  final String destinationName;
  final VoidCallback onSwap;
  final ValueChanged<String>? onDepartureSelect;

  const _DirectionTopPanel({
    required this.departureName,
    required this.destinationName,
    required this.onSwap,
    this.onDepartureSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: dark ? AppColors.bgSurfaceDark : AppColors.bgSurface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 67),
              child: GestureDetector(
                onTap: onSwap,
                behavior: HitTestBehavior.opaque,
                child: AppIcons.crossArrow(),
              ),
            ),
            AppGap.h16,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DirectionFieldBlock(
                    label: '출발',
                    value: departureName,
                    placeholder: '학교',
                    showChevron: true,
                    options: const ['내 위치', '학교'],
                    onOptionSelected: onDepartureSelect,
                  ),
                  AppGap.v4,
                  _DirectionFieldBlock(
                    label: '도착',
                    value: destinationName,
                    placeholder: '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionFieldBlock extends ConsumerStatefulWidget {
  final String label;
  final String value;
  final String placeholder;
  final bool showChevron;
  final List<String>? options;
  final ValueChanged<String>? onOptionSelected;

  const _DirectionFieldBlock({
    required this.label,
    required this.value,
    required this.placeholder,
    this.showChevron = false,
    this.options,
    this.onOptionSelected,
  });

  @override
  ConsumerState<_DirectionFieldBlock> createState() =>
      _DirectionFieldBlockState();
}

class _DirectionFieldBlockState extends ConsumerState<_DirectionFieldBlock> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _containerKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final containerBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    final containerHeight = containerBox.size.height;

    final themeMode = switch (ref.read(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);
    final bgColor =
        dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;
    final textColor = dark ? AppColors.mainTextDark : AppColors.mainText;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideDropdown,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, containerHeight + 6),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        widget.options!.length,
                        (i) {
                          final option = widget.options![i];
                          final isLast = i == widget.options!.length - 1;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _hideDropdown();
                                  widget.onOptionSelected?.call(option);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: AppTextStyles.text2.copyWith(
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                Divider(
                                  height: 1,
                                  color: dark
                                      ? AppColors.buttonDark
                                      : AppColors.button,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value.trim().isNotEmpty;

    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    final textColor = dark ? AppColors.sub1Dark : AppColors.sub1;
    final bgColor =
        dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.text3.copyWith(color: textColor),
        ),
        AppGap.v4,
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (widget.options != null && widget.options!.isNotEmpty)
                ? _toggleDropdown
                : null,
            child: Container(
              key: _containerKey,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? widget.value : widget.placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.text3.copyWith(
                        color: hasValue
                            ? textColor
                            : dark
                                ? AppColors.sub2Dark
                                : AppColors.sub2,
                      ),
                    ),
                  ),
                  if (widget.showChevron) AppIcons.downArrow(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DirectionRouteCarousel extends StatelessWidget {
  final ScrollController scrollController;
  final List<RouteOption> routeOptions;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _DirectionRouteCarousel({
    required this.scrollController,
    required this.routeOptions,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (routeOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 168,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final option = routeOptions[index];
          return SizedBox(
            width: 208,
            child: _RouteOptionCard(
              option: option,
              isSelected: selectedIndex == index,
              onTap: () => onTap(index),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: routeOptions.length,
      ),
    );
  }
}

class _RouteOptionCard extends ConsumerWidget {
  final RouteOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.bgSurfaceDark : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.mainColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  option.label,
                  style: AppTextStyles.text1.copyWith(
                    color: dark ? AppColors.sub1Dark : AppColors.sub1,
                  ),
                ),
                AppGap.h4,
                AppIcons.rightArrow(),
              ],
            ),
            AppGap.v4,
            Text(
              '${option.minutes}분',
              style: AppTextStyles.title3.copyWith(
                color: dark ? AppColors.mainTextDark : AppColors.mainText,
                fontSize: 18,
              ),
            ),
            AppGap.v4,
            Text(
              '${option.meters}m',
              style: AppTextStyles.text2.copyWith(
                color: dark ? AppColors.sub2Dark : AppColors.sub2,
              ),
            ),
            AppGap.v4,
            Text(
              '택시 예상 ${_formatWon(option.taxiFare)}',
              style: AppTextStyles.text2.copyWith(
                color: dark ? AppColors.sub2Dark : AppColors.sub2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionDetailSheet extends ConsumerWidget {
  final RouteOption option;
  final String departureName;
  final String destinationName;
  final VoidCallback onClose;

  const _DirectionDetailSheet({
    required this.option,
    required this.departureName,
    required this.destinationName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    final sheetBg =
        dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;
    final textColor = dark ? AppColors.mainTextDark : AppColors.mainText;
    final subColor = dark ? AppColors.sub1Dark : AppColors.sub1;
    final dividerColor = dark ? AppColors.buttonDark : AppColors.button;
    final shadowColor = (dark ? AppColors.backgroundDark : AppColors.background)
        .withValues(alpha: 0.22);

    return Container(
      height: 460,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          AppGap.v12,
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: subColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${departureName.isEmpty ? '학교' : departureName} -> $destinationName',
                        style: AppTextStyles.text2.copyWith(color: subColor),
                      ),
                      AppGap.v8,
                      Text(
                        '${option.label} 경로',
                        style: AppTextStyles.title3.copyWith(color: textColor),
                      ),
                      AppGap.v12,
                      Text(
                        '${option.minutes}분',
                        style: AppTextStyles.title1.copyWith(color: textColor),
                      ),
                      AppGap.v4,
                      Text(
                        '${option.meters}m | 통행료 ${_formatWon(option.tollFare)}',
                        style: AppTextStyles.text3.copyWith(color: subColor),
                      ),
                      AppGap.v4,
                      Text(
                        '택시 예상 ${_formatWon(option.taxiFare)}',
                        style: AppTextStyles.text3.copyWith(color: subColor),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close_rounded,
                    color: subColor,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
              itemBuilder: (_, index) => _DirectionStepTile(
                step: option.steps[index],
                dark: dark,
              ),
              separatorBuilder: (_, __) => Divider(
                color: dividerColor,
                height: 1,
              ),
              itemCount: option.steps.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionStepTile extends StatelessWidget {
  final RouteStep step;
  final bool dark;

  const _DirectionStepTile({required this.step, required this.dark});

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? AppColors.mainTextDark : AppColors.mainText;
    final descColor = dark ? AppColors.sub1Dark : AppColors.sub1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Icon(
              _iconForStep(step),
              color: AppColors.mainColor,
              size: 30,
            ),
          ),
          AppGap.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.text1.copyWith(color: textColor),
                ),
                AppGap.v4,
                Text(
                  step.description,
                  style: AppTextStyles.text3.copyWith(color: descColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForStep(RouteStep step) {
    if (step.type == 100) {
      return Icons.location_on_outlined;
    }
    if (step.type == 101) {
      return Icons.flag_outlined;
    }
    if (step.title.contains('좌회전')) {
      return Icons.turn_left_rounded;
    }
    if (step.title.contains('우회전')) {
      return Icons.turn_right_rounded;
    }
    if (step.title.contains('유턴')) {
      return Icons.u_turn_left_rounded;
    }
    return Icons.straight_rounded;
  }
}

String _formatWon(int value) {
  if (value <= 0) {
    return '0원';
  }
  return '${value.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      )}원';
}
