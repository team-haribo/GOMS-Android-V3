import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/map_page/models/map_page_review_model.dart';
import 'package:project_setting/presentation/map_page/models/map_page_state.dart';
import 'package:project_setting/presentation/map_page/models/popular_place.dart';
import 'package:project_setting/presentation/map_page/viewModels/map_page_provider.dart';
import 'package:project_setting/presentation/map_page/widget/drag_handle_header.dart';
import 'package:project_setting/presentation/map_page/widget/place_container.dart';
import 'package:project_setting/presentation/map_page/widget/place_review_container.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/text_fields/search_text_field.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  @override
  void dispose() {
    sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapPageProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    ref.listen(mapPageProvider, (previous, next) {
      if (!mounted) return;
      if (next.status == MapPageStatus.failure && next.errorMessage != null) {
        ref.read(mapPageProvider.notifier).clearError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    });

    return BaseScaffold(
      showAppBar: false,
      contentPadding: EdgeInsets.zero,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SearchTextField(),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.37,
                    minChildSize: 0.37,
                    maxChildSize: 0.85,
                    snap: true,
                    snapSizes: const [0.37, 0.6, 0.85],
                    builder: (context, scrollController) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLight
                                ? AppColors.bgSurface
                                : AppColors.bgSurfaceDark,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: DragHandleHeader(),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _PopularPlacesSection(
                                        isLight: isLight,
                                        status: state.status,
                                        popularPlaces: state.popularPlaces,
                                      ),
                                      AppGap.v16,
                                      _MyActivitySection(
                                        isLight: isLight,
                                        popularPlaces: state.popularPlaces,
                                        reviewModels: state.reviewModels,
                                        recommendedCount:
                                            state.recommendedCount,
                                        reviewCount: state.reviewCount,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 57,
                  child: _BottomGradient(isLight: isLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 섹션 위젯 ====================

class _PopularPlacesSection extends StatelessWidget {
  final bool isLight;
  final MapPageStatus status;
  final List<PopularPlace> popularPlaces;

  const _PopularPlacesSection({
    required this.isLight,
    required this.status,
    required this.popularPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '최근 인기 장소',
              style: AppTextStyles.title3.copyWith(
                color: isLight ? AppColors.mainText : AppColors.mainTextDark,
              ),
            ),
            AppGap.v2,
            AppIcons.fire(color: AppColors.negative),
          ],
        ),
        AppGap.v16,
        if (status == MapPageStatus.loading)
          const Center(child: CircularProgressIndicator())
        else
          ...popularPlaces.map(
            (place) => Column(
              children: [
                PlaceContainer(
                  placeName: place.name,
                  category: place.category,
                  address: place.address,
                  review: place.review,
                  recommended: place.recommended,
                ),
                AppGap.v12,
              ],
            ),
          ),
      ],
    );
  }
}

class _MyActivitySection extends StatelessWidget {
  final bool isLight;
  final List<PopularPlace> popularPlaces;
  final List<MapPageReviewModel> reviewModels;
  final int recommendedCount;
  final int reviewCount;

  const _MyActivitySection({
    required this.isLight,
    required this.popularPlaces,
    required this.reviewModels,
    required this.recommendedCount,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 활동',
          style: AppTextStyles.title3.copyWith(
            color: isLight ? AppColors.mainText : AppColors.mainTextDark,
          ),
        ),
        AppGap.v16,
        _ActivityCountRow(
          isLight: isLight,
          label: '추천한 가게',
          count: recommendedCount,
          unit: '곳',
          labelStyle: AppTextStyles.text1,
          countStyle: AppTextStyles.text3,
        ),
        ...popularPlaces.map(
          (place) => Column(
            children: [
              AppGap.v12,
              PlaceContainer(
                placeName: place.name,
                category: place.category,
                address: place.address,
                review: place.review,
                recommended: place.recommended,
              ),
            ],
          ),
        ),
        AppGap.v16,
        _ActivityCountRow(
          isLight: isLight,
          label: '작성한 후기',
          count: reviewCount,
          unit: '건',
          labelStyle: AppTextStyles.text3,
          countStyle: AppTextStyles.text1,
        ),
        ...reviewModels.map(
          (review) => Column(
            children: [
              AppGap.v12,
              PlaceReviewContainer(
                placeName: review.placeName,
                category: review.category,
                address: review.address,
                reviewDetailContent: review.reviewDetailContent,
                createdAt: review.createdAt,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityCountRow extends StatelessWidget {
  final bool isLight;
  final String label;
  final int count;
  final String unit;
  final TextStyle labelStyle;
  final TextStyle countStyle;

  const _ActivityCountRow({
    required this.isLight,
    required this.label,
    required this.count,
    required this.unit,
    required this.labelStyle,
    required this.countStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: labelStyle.copyWith(
            color: isLight ? AppColors.mainText : AppColors.mainTextDark,
          ),
        ),
        AppGap.h4,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$count',
                style: countStyle.copyWith(color: AppColors.mainColor),
              ),
              TextSpan(
                text: unit,
                style: countStyle.copyWith(
                  color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomGradient extends StatelessWidget {
  final bool isLight;

  const _BottomGradient({required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isLight
                ? AppColors.bgSurface.withAlpha(0)
                : AppColors.bgSurfaceDark.withAlpha(0),
            isLight
                ? AppColors.bgSurface.withAlpha(255)
                : AppColors.bgSurfaceDark.withAlpha(255),
          ],
        ),
      ),
    );
  }
}
