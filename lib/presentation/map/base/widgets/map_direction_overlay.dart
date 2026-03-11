import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/presentation/map/direction/models/direction_state.dart';
import 'package:goms/presentation/map/main/models/popular_place.dart';

class MapDirectionOverlay extends StatefulWidget {
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
  State<MapDirectionOverlay> createState() => _MapDirectionOverlayState();
}

class _MapDirectionOverlayState extends State<MapDirectionOverlay> {
  final ScrollController _routeScrollController = ScrollController();
  bool _isRouteSheetVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_routeScrollController.hasClients) {
        _routeScrollController.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _routeScrollController.dispose();
    super.dispose();
  }

  void _handleRouteTap(int index) {
    widget.onSelect(index);
    setState(() {
      _isRouteSheetVisible = true;
    });
  }

  void _closeRouteSheet() {
    if (!_isRouteSheetVisible) return;
    setState(() {
      _isRouteSheetVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = widget.state.routeOptions.isEmpty
        ? null
        : widget.state.routeOptions[widget.state.selectedRouteIndex];
    final departureName = widget.state.departure;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _DirectionTopPanel(
            departureName: departureName,
            destinationName: widget.place.name,
            onSwap: widget.onSwap,
            onDepartureSelect: widget.onDepartureSelect,
          ),
        ),
        if (_isRouteSheetVisible && selectedOption != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeRouteSheet,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withValues(alpha: 0.18),
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
              selectedIndex: widget.state.selectedRouteIndex,
              onTap: _handleRouteTap,
            ),
            routeSheet: selectedOption == null
                ? const SizedBox.shrink()
                : _DirectionDetailSheet(
                    option: selectedOption,
                    departureName: departureName,
                    destinationName: widget.place.name,
                    onClose: _closeRouteSheet,
                  ),
            isRouteSheetVisible: _isRouteSheetVisible,
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
          child: CircularProgressIndicator(
            color: AppColors.mainColor,
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.18),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      child: isRouteSheetVisible
          ? KeyedSubtree(
              key: ValueKey('route-sheet-${state.selectedRouteIndex}'),
              child: routeSheet,
            )
          : KeyedSubtree(
              key: const ValueKey('route-carousel'),
              child: routeCarousel,
            ),
    );
  }
}

class _DirectionTopPanel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgSurfaceDark : AppColors.bgSurface,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
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

class _DirectionFieldBlock extends StatefulWidget {
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
  State<_DirectionFieldBlock> createState() => _DirectionFieldBlockState();
}

class _DirectionFieldBlockState extends State<_DirectionFieldBlock> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;
    final textColor = isDark ? AppColors.mainTextDark : AppColors.mainText;

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
                                  color: isDark
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.sub1Dark : AppColors.sub1;
    final bgColor =
        isDark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;

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
                            : isDark
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
    if (routeOptions.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final option = routeOptions[index];
          return SizedBox(
            width: 192,
            child: _RouteOptionCard(
              option: option,
              onTap: () => onTap(index),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 12,
        ),
        itemCount: routeOptions.length,
      ),
    );
  }
}

class _RouteOptionCard extends StatelessWidget {
  final RouteOption option;
  final VoidCallback onTap;

  const _RouteOptionCard({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgSurfaceDark : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  option.label,
                  style: AppTextStyles.text1.copyWith(
                    color: isDark ? AppColors.sub1Dark : AppColors.sub1,
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
                color: isDark ? AppColors.mainTextDark : AppColors.mainText,
                fontSize: 18,
              ),
            ),
            AppGap.v4,
            Text(
              '${option.meters}m | ${option.calories}kcal',
              style: AppTextStyles.text2.copyWith(
                color: isDark ? AppColors.sub2Dark : AppColors.sub2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionDetailSheet extends StatelessWidget {
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

  static const _labelDeparture = '출발';
  static const _labelArrival = '도착';
  static const _labelDefaultDeparture = '학교';
  static const _labelTurnLeft = '좌회전';
  static const _labelTurnRight = '우회전';
  static const _labelStraight = '직진';
  static const _labelMove = '이동';
  static const _labelTowardSuffix = '방면 이동';

  List<_DirectionStepData> _buildSteps() {
    final firstDistance = (option.meters * 0.42).round();
    final secondDistance = (option.meters * 0.33).round();
    final thirdDistance = option.meters - firstDistance - secondDistance;

    return [
      _DirectionStepData(
        icon: Icons.location_on_outlined,
        title: _labelDeparture,
        description:
            departureName.isEmpty ? _labelDefaultDeparture : departureName,
      ),
      _DirectionStepData(
        icon: Icons.straight_rounded,
        title: '$destinationName $_labelTowardSuffix',
        description: '${firstDistance}m $_labelStraight',
      ),
      _DirectionStepData(
        icon: Icons.turn_left_rounded,
        title: _labelTurnLeft,
        description: '${secondDistance}m $_labelMove',
      ),
      _DirectionStepData(
        icon: Icons.turn_right_rounded,
        title: _labelTurnRight,
        description: '${thirdDistance}m $_labelMove',
      ),
      _DirectionStepData(
        icon: Icons.location_on_outlined,
        title: _labelArrival,
        description: destinationName,
        isArrival: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps();

    return Container(
      height: 452,
      decoration: BoxDecoration(
        color: const Color(0xFF111315),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
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
              color: const Color(0xFF6F747B),
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
                        '${option.label} 경로',
                        style:
                            AppTextStyles.title3.copyWith(color: Colors.white),
                      ),
                      AppGap.v12,
                      Text(
                        '${option.minutes}분',
                        style:
                            AppTextStyles.title1.copyWith(color: Colors.white),
                      ),
                      AppGap.v4,
                      Text(
                        '${option.meters}m | ${option.calories}kcal',
                        style: AppTextStyles.text3.copyWith(
                          color: const Color(0xFF8A8D91),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF8A8D91),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
              itemBuilder: (context, index) {
                return _DirectionStepTile(step: steps[index]);
              },
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFF262A2F),
                height: 1,
              ),
              itemCount: steps.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionStepTile extends StatelessWidget {
  final _DirectionStepData step;

  const _DirectionStepTile({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Icon(
              step.icon,
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
                  style: AppTextStyles.text1.copyWith(color: Colors.white),
                ),
                AppGap.v4,
                Text(
                  step.description,
                  style: AppTextStyles.text3.copyWith(
                    color:
                        step.isArrival ? Colors.white : const Color(0xFFD5D7DA),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionStepData {
  final IconData icon;
  final String title;
  final String description;
  final bool isArrival;

  const _DirectionStepData({
    required this.icon,
    required this.title,
    required this.description,
    this.isArrival = false,
  });
}
