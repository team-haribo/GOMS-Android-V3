import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/presentation/map/direction/models/direction_state.dart';
import 'package:goms/presentation/map/main/models/popular_place.dart';

/// 로컬 설정(themeModeProvider) 기반으로 다크모드 여부를 반환합니다.
/// ThemeMode.system 일 때는 실제 디바이스 밝기를 참조합니다.
bool _isDark(ThemeMode mode, BuildContext context) {
  if (mode == ThemeMode.system) {
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }
  return mode == ThemeMode.dark;
}

// ─────────────────────────────────────────────────────────────────────────────
// MapDirectionOverlay
// 지도 길찾기 모드 전체 오버레이 (상단 입력 패널 + 하단 경로 목록/상세)
// ─────────────────────────────────────────────────────────────────────────────
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
  ConsumerState<MapDirectionOverlay> createState() => _MapDirectionOverlayState();
}

class _MapDirectionOverlayState extends ConsumerState<MapDirectionOverlay> {
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
    setState(() => _isRouteSheetVisible = true);
  }

  void _closeRouteSheet() {
    if (!_isRouteSheetVisible) return;
    setState(() => _isRouteSheetVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = widget.state.routeOptions.isEmpty
        ? null
        : widget.state.routeOptions[widget.state.selectedRouteIndex];
    final departureName = widget.state.departure;

    // 로컬 저장소 기반 다크모드 여부
    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };

    return Stack(
      children: [
        // 상단: 출발지·도착지 입력 패널
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

        // 경로 상세 시트가 열릴 때 표시되는 반투명 딤(dim) 배경
        if (_isRouteSheetVisible && selectedOption != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeRouteSheet,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: (_isDark(themeMode, context)
                        ? AppColors.backgroundDark
                        : AppColors.background)
                    .withOpacity(0.18), // 색 변경 예정
              ),
            ),
          ),

        // 하단: 로딩 / 경로 목록 카드 / 경로 상세 시트
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
    // 로딩 중 스피너 표시
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

    // 경로 상세 시트 ↔ 카드 캐러셀 전환
    return isRouteSheetVisible ? routeSheet : routeCarousel;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DirectionTopPanel
// 화면 상단: 출발지·도착지 입력 필드 + 스왑 버튼
// ─────────────────────────────────────────────────────────────────────────────
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
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 출발/도착 스왑 버튼
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

// ─────────────────────────────────────────────────────────────────────────────
// _DirectionFieldBlock
// 출발/도착 텍스트 입력 필드 (드롭다운 오버레이 포함)
// ─────────────────────────────────────────────────────────────────────────────
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

    // 드롭다운 생성 시점의 테마 읽기 (ref.read: 단발성)
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

    // 로컬 저장소 기반 다크모드 여부 (ref.watch: 테마 변경 시 자동 갱신)
    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    final textColor = dark ? AppColors.sub1Dark : AppColors.sub1;
    final bgColor = dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨 (출발 / 도착)
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

// ─────────────────────────────────────────────────────────────────────────────
// _DirectionRouteCarousel
// 하단 경로 옵션 카드 가로 스크롤 목록
// ─────────────────────────────────────────────────────────────────────────────
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
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: routeOptions.length,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RouteOptionCard
// 경로 옵션 하나를 표시하는 카드 (라벨 / 소요시간 / 거리·칼로리)
// ─────────────────────────────────────────────────────────────────────────────
class _RouteOptionCard extends ConsumerWidget {
  final RouteOption option;
  final VoidCallback onTap;

  const _RouteOptionCard({
    required this.option,
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
              '${option.meters}m | ${option.calories}kcal',
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

// ─────────────────────────────────────────────────────────────────────────────
// _DirectionDetailSheet
// 하단에서 올라오는 경로 상세 시트
// ─────────────────────────────────────────────────────────────────────────────
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
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = _buildSteps();
    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };
    final dark = _isDark(themeMode, context);

    final sheetBg = dark ? AppColors.bgMapContainerDark : AppColors.bgMapContainer;
    final textColor = dark ? AppColors.mainTextDark : AppColors.mainText;
    final subColor = dark ? AppColors.sub1Dark : AppColors.sub1;
    final dividerColor = dark ? AppColors.buttonDark : AppColors.button;
    final shadowColor = (dark ? AppColors.backgroundDark : AppColors.background)
        .withOpacity(0.22); // 색 변경 예정

    return Container(
      height: 452,
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
          // 드래그 핸들
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
                        '${option.meters}m | ${option.calories}kcal',
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
              itemBuilder: (_, index) =>
                  _DirectionStepTile(step: steps[index], dark: dark),
              separatorBuilder: (_, __) => Divider(
                color: dividerColor,
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

// ─────────────────────────────────────────────────────────────────────────────
// _DirectionStepTile
// 경로 상세 시트 내 단계별 리스트 아이템
// ─────────────────────────────────────────────────────────────────────────────
class _DirectionStepTile extends StatelessWidget {
  final _DirectionStepData step;
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
                  style: AppTextStyles.text1.copyWith(color: textColor),
                ),
                AppGap.v4,
                Text(
                  step.description,
                  style: AppTextStyles.text3.copyWith(
                    // 도착지는 메인 텍스트 색, 중간 단계는 서브 색
                    color: step.isArrival ? textColor : descColor,
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

// ─────────────────────────────────────────────────────────────────────────────
// _DirectionStepData
// 경로 상세 단계 데이터 모델
// ─────────────────────────────────────────────────────────────────────────────
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
